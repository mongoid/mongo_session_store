# MongoSessionStore

[![Build Status](https://travis-ci.org/mongoid/mongo_session_store.svg?branch=master)](https://travis-ci.org/mongoid/mongo_session_store)
[![Gem Version](https://badge.fury.io/rb/mongo_session_store.svg)](http://badge.fury.io/rb/mongo_session_store)
[![Code Climate](https://codeclimate.com/github/mongoid/mongo_session_store/badges/gpa.svg)](https://codeclimate.com/github/mongoid/mongo_session_store)

## Description

MongoSessionStore is a [Rails][rails]-compatible session store for
[MongoDB][mongodb] using either [Mongoid][mongoid] or the [MongoDB Ruby
Driver][mongo]. It also allows for custom Mongo session store that works with
any (or no!) Mongo ODM.

MongoSessionStore version 3 is compatible with Rails 4.0 through 5.1. For Rails
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

## Development

### Testing

To run the tests for a specific store. You must first set a `BUNDLE_GEMFILE` in
the environment.

```sh
bundle exec rake
```

Examples:

```sh
BUNDLE_GEMFILE=gemfiles/rails-4.0-mongo.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-4.0-mongoid.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-4.1-mongo.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-4.1-mongoid.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-4.2-mongo.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-4.2-mongoid.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-5.0-mongo.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-5.0-mongoid.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-5.1-mongo.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-5.1-mongoid.gemfile bundle exec rake
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
