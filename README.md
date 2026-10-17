# MongoSessionStore

[![CI](https://github.com/mongoid/mongo_session_store/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/mongoid/mongo_session_store/actions/workflows/ci.yml?query=branch%3Amain)
[![Gem Version](https://badge.fury.io/rb/mongo_session_store.svg)](http://badge.fury.io/rb/mongo_session_store)
[![Coverage Status](https://coveralls.io/repos/github/mongoid/mongo_session_store/badge.svg?branch=main)](https://coveralls.io/github/mongoid/mongo_session_store?branch=main)

## Description

MongoSessionStore is a [Rails][rails]-compatible session store for
[MongoDB][mongodb] using either [Mongoid][mongoid] or the [MongoDB Ruby
Driver][mongo]. It also allows for custom Mongo session store that works with
any (or no!) Mongo ODM.

MongoSessionStore version 3 is compatible with Rails 5.0+. For Rails
3 support please check out issue [#17][issue-rails3] for options and let us
know if you need support.

## Installation

Add the `mongo_session_store` gem to your `Gemfile`.
Use either the `mongo` or `mongoid` gems in combination with this gem.

```ruby
# Gemfile

gem "mongoid"
# or gem "mongo"
gem "mongo_session_store"
```

Configure the session store in the session_store initializer in your Rails
project.

```ruby
# config/initializers/session_store.rb

# Mongoid
MyApp::Application.config.session_store :mongoid_store

# MongoDB Ruby Driver/anything else
MongoStore::Session.database = Mongo::Client.new(["127.0.0.1:27017"], database: "my_app_development")
MyApp::Application.config.session_store :mongo_store
```

## Configuration

By default, the sessions will be stored in the "sessions" collection in
MongoDB. If you want to use a different collection, you can set that in the
session_store initializer.

```ruby
# config/initializers/session_store.rb
MongoSessionStore.collection_name = "client_sessions"
```

## Usage

By default nothing has to be done outside the [installation](#installation) of
the gem.

It's possible to query your sessions.

```ruby
# Mongoid
MongoidStore::Session.where(:updated_at.gt => 2.days.ago)

# MongoDB Ruby Driver
MongoStore::Session.where("updated_at" => { "$gt" => 2.days.ago })
```

### Serializable session values

Both adapters serialize session data with Ruby's `Marshal`. Store serializable values such as strings, numbers, arrays, and hashes, not requests, input streams, or uploaded files. Serialization errors are raised rather than silently discarding data.

Do not store `ActionController::Parameters` objects directly in the session. On Rails 7 and newer, their logging context can retain the request and its input stream, causing `TypeError: can't dump IO` (or a similar error for `StringIO`). A nested `params[:search]` object can retain that context too. Explicitly permit the values your application needs and convert them to a hash before saving:

```ruby
session[:search] = params.require(:search).permit(:query, :sort).to_h
```

This stores the permitted values without the request context. It does not make uploaded files or other non-serializable values serializable; store a durable identifier for those instead.

## Development

### Test environment

Start MongoDB with this script:

```
script/testenv
```

### Testing

To run the tests for a specific store. You must first set a `BUNDLE_GEMFILE` in
the environment.

You can also use Docker, see the section below this one.

```sh
bundle exec rake
```

Examples:

```sh
BUNDLE_GEMFILE=gemfiles/rails-5.0-mongo.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-5.0-mongoid.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-5.1-mongo.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-5.1-mongoid.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-5.2-mongo.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-5.2-mongoid.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-6.0-mongo.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-6.0-mongoid.gemfile bundle exec rake
```

For Rails 6.1 and newer, use `gemfiles/rails-current-mongo.gemfile` or `gemfiles/rails-current-mongoid.gemfile` with `RAILS_VERSION` and, for Mongoid, `MONGOID_VERSION` constraints:

```sh
RAILS_VERSION='~> 7.2.0' MONGOID_VERSION='~> 9.0' BUNDLE_GEMFILE=gemfiles/rails-current-mongoid.gemfile bundle exec rake test
```

For Rails 8.0, also set `SQLITE_VERSION='~> 2.1'`; the dedicated Rails 8.1 Gemfiles already select SQLite 2.

Set `MONGODB_HOST` and `MONGODB_PORT` to use a non-default test server. The default is `127.0.0.1:27017`.

#### Docker testing

To run tests in a Docker container with a specific Ruby version and gemfile:

```sh
BUNDLE_GEMFILE=gemfiles/rails-6.0-mongo.gemfile script/test
```

The `BUNDLE_GEMFILE` environment variable is required. Ruby version defaults to 3.4 but can be customized:

```sh
RUBY_VERSION=2.7 BUNDLE_GEMFILE=gemfiles/rails-6.0-mongo.gemfile script/test
```

### Performance benchmark

The repository includes a performance benchmark. It runs against all available
included stores and outputs the results.

```
bundle exec ruby perf/benchmark.rb
```

### Releases

To create a new release checkout the `master` branch and make sure it's in the
right state to release. Run the `release` Rake task and follow the
instructions.

```
bundle exec rake release
```

## Contributors

MongoSessionStore started as a fork of the DataMapper session store, modified
to work with MongoMapper, Mongoid and the Mongo Ruby Driver.

Much thanks to all contributors:

* Nicolas Mérouze
* Chris Brickley
* Tony Pitale
* Nicola Racco
* Matt Powell
* Ryan Fitzgerald
* Brian Hempel
* Tom de Bruijn

## License

Released under the MIT license. See the [LICENSE](LICENSE) file.

[mongodb]: https://www.mongodb.com/
[mongo]: https://github.com/mongodb/mongo-ruby-driver
[mongoid]: http://mongoid.org/
[rails]: http://rubyonrails.org/

[issue-rails3]: https://github.com/mongoid/mongo_session_store/issues/17
