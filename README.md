# QuasarRestClient

Wrap the [Quasar](http://quasar-analytics.org/ "Quasar NoSQL Analytics
Engine")  [RESTful API](http://quasar-analytics.org/docs/restapi/
"Quasar RESTful API Documentation") to drop into Ruby applications.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'quasar_rest_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install quasar_rest_client

## Usage

### Configuration

#### Endpoint

Stores the endpoint of the Quasar service:

    QuasarRestClient.config.endpoint = 'http://example.com'

#### Logger

Stores an optional logger object implementing the `Logger` interface.

    require 'logger'
    QuasarRestClient.config.logger = Logger.new($stderr)

#### Alternate configuration style

You can also perform the configuration in block-style

    require 'logger'
    QuasarRestClient.configure do |config|
	  config.endpoint = 'http://example.com'
      config.logger = Logger.new($stderr)
    end

### Queries

#### Simple Query

##### REQUEST

`QuasarRestClient.simple_query(query, options)`

* Calls your quasar instance with a simple query as described in
http://quasar-analytics.org/docs/restapi/#small-query

* `query` [String] -- contains the SQL^2 query string, for example:

        SELECT * from `/sample/data/SampleJSON` WHERE state="WA"

  Note that the documentation is wrong about quoting. The source name
  (and other database names) should be **backticked** (like in
  Postgresql) and strings need to be surrounded with **double
  quotes**, not single quotes.

* `options` [Hash] -- a hash object with the following key:

  * `limit` [Numeric Value] -- number of records to retrieve in this
    query

  * `offset` [Numeric Value] -- record to start retreival at
    (zero-based)

  * `var` [Hash] -- a hash of key-value pairs where the key
    corresponds to a variable name used in the query string.

##### RESPONSE

The call responds with a JSON object with the result of the query,
which could either be data or an error.

## Exceptions

There are no exceptions raised explicitly in the library, but
underlying libraries may raise them, and as this is a networked
utility, one could get errors because of the inherent instability of
the network.


## Development

After checking out the repo, run `bin/setup` to install
dependencies. Then, run `rake test` to run the tests. You can also run
`bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake
install`. To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which will
create a git tag for the version, push git commits and tags, and push
the `.gem` file to [rubygems.org](https://rubygems.org).

### Live Testing

To live test the client, you will need a working quasar server, and a
working mongodb server with data in it.

The `./live_spec` directory contains the spec tests for live testing,
and depends up on the `./live_spec/config/config.yml` file to be set
with the appropriate information to make the connection work. You can
copy the `./live_spec/config/config.sample.yml` file and fill in the
details.

A rake task `live_spec` is also available to make running these tests
simpler.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/riverock/quasar_rest_client.

This project is intended to be a safe, welcoming space for
collaboration, and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of
conduct.
