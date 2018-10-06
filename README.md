## fluent-plugin-osquery

[osquery](https://osquery.io/) input plugin

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-osquery'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-osquery

When you use with td-agent, install it as below:

    $ sudo /opt/td-agent/embedded/bin/fluent-gem install fluent-plugin-osquery

Create home directory: (It could be unnecessary)

    $ sudo mkdir -p /home/td-agent/.osquery
    $ sudo chown td-agent /home/td-agent/.osquery

## Configuration

### Example

    <source>
      @type osquery
      tag osquery
      interval 60
      query select * from processes
    </source>

    <match osquery>
      @type stdout
    </match>

## Copyright

Copyright (c) 2015 Hidenori Suzuki. See [LICENSE](LICENSE) for details.

