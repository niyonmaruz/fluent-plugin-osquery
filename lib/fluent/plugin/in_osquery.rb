# coding: utf-8
require 'json'
require 'fluent/plugin/input'

module Fluent::Plugin
  class OsqueryInput < Fluent::Plugin::Input
    Fluent::Plugin.register_input('osquery', self)

    helpers :timer

    config_param :tag, :string, default: 'osquery'
    config_param :interval, :integer, default: 60
    config_param :query, :string, default: 'select * from processes'

    unless method_defined?(:router)
      define_method("router") { Fluent::Engine }
    end

    def initialize
      super
    end

    def configure(conf)
      super
    end

    def start
      super
      timer_execute(:in_osquery_timer, interval, &method(:execute))
    end

    def shutdown
      super
    end

    private

    def execute
      @time = Fluent::Engine.now
      cmd = "osqueryi --json \"#{@query}\""
      log.debug(cmd)
      record = `#{cmd}`
      jsonrec = JSON.parse(record)
      jsonrec.each do |line|
        log.debug(line)
        router.emit(@tag, @time, line)
      end
    rescue => e
      log.error('faild to run', error: e.to_s, error_class: e.class.to_s)
      log.error_backtrace
    end
  end
end
