## fluent-plugin-osquery

[osquery](https://osquery.io/) input plugin

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-osquery'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-osquery

## Configuration

### Example

    <source>
      type osquery
      tag osquery
      interval 60
      query select * from processes
    </source>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Copyright

Copyright (c) 2015 Hidenori Suzuki. See [LICENSE](LICENSE) for details.

