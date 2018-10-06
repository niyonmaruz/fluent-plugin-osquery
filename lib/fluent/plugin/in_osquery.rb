# coding: utf-8
require 'fluent/input'
module Fluent
  class OsqueryInput < Fluent::Input
    Fluent::Plugin.register_input('osquery', self)
    config_param :tag, :string, default: 'osquery'
    config_param :interval, :integer, default: 60
    config_param :query, :string, default: 'select * from processes'

    unless method_defined?(:router)
      define_method("router") { Fluent::Engine }
    end

    def initialize
      super
      require 'json'
    end

    def configure(conf)
      super
    end

    def start
      @loop = Coolio::Loop.new
      @tw = TimerWatcher.new(interval, true, log, &method(:execute))
      @tw.attach(@loop)
      @thread = Thread.new(&method(:run))
    end

    def shutdown
      @tw.detach
      @loop.stop
      @thread.join
    end

    def run
      @loop.run
    rescue => e
      @log.error 'unexpected error', error: e.to_s
      @log.error_backtrace
    end

    private

    def execute
      @time = Engine.now
      cmd = "osqueryi --json \"#{@query}\""
      @log.debug(cmd)
      record = `#{cmd}`
      jsonrec = JSON.parse(record)
      jsonrec.each do |line|
        @log.debug(line)
        router.emit(@tag, @time, line)
      end
    rescue => e
      @log.error('faild to run', error: e.to_s, error_class: e.class.to_s)
      @log.error_backtrace
    end

    class TimerWatcher < Coolio::TimerWatcher
      def initialize(interval, repeat, log, &callback)
        @log = log
        @callback = callback
        super(interval, repeat)
      end

      def on_timer
        @callback.call
      rescue => e
        @log.error e.to_s
        @log.error_backtrace
      end
    end
  end
end
