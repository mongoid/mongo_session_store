# MongoSessionStore

[![Build Status](https://travis-ci.org/mongoid/mongo_session_store.png?branch=master)](https://travis-ci.org/mongoid/mongo_session_store) [![Gem Version](https://badge.fury.io/rb/mongo_session_store.svg)](http://badge.fury.io/rb/mongo_session_store)

## Description

MongoSessionStore is a Rails-compatible session store for Mongo using either
Mongoid or the Ruby MongoDB driver. It also allows for custom Mongo session
store that works with any (or no!) Mongo ODM.

## Usage

MongoSessionStore is compatible with Rails 4.0 through 4.2.

In your Gemfile:

```ruby
gem "mongoid"
# or gem "mongo"
gem "mongo_session_store"
```

In the session_store initializer:

```ruby
# config/initializers/session_store.rb

# Mongoid
MyApp::Application.config.session_store :mongoid_store

# anything else
MongoStore::Session.database = Mongo::Client.new(["127.0.0.1:27017"], database: "my_app_development")
MyApp::Application.config.session_store :mongo_store
```

By default, the sessions will be stored in the "sessions" collection in
MongoDB. If you want to use a different collection, you can set that in the
initializer:

```ruby
# config/initializers/session_store.rb
MongoSessionStore.collection_name = "client_sessions"
```

And if you want to query your sessions:

```ruby
# Mongoid
MongoidStore::Session.where(:updated_at.gt => 2.days.ago)

# Plain old Mongo
MongoStore::Session.where('updated_at' => { '$gt' => 2.days.ago })
```

## Development

To run all the tests:

```sh
rake
```

To run the tests for a specific store:

```sh
BUNDLE_GEMFILE=gemfiles/rails-4.0-mongo.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-4.0-mongoid.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-4.1-mongo.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-4.1-mongoid.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-4.2-mongo.gemfile bundle exec rake
BUNDLE_GEMFILE=gemfiles/rails-4.2-mongoid.gemfile bundle exec rake
```

## Performance benchmark

The repository includes a performance benchmark. It runrs against all available
included stores and outputs the results.

```
ruby perf/benchmark.rb
```

## Releases

To create a new release checkou the `master` branch and make sure it's in the
right state to release. Run the `release` Rake task and follow the
instructions.

```
rake release
```

## Previous contributors

MongoSessionStore started as a fork of the DataMapper session store, modified
to work with MongoMapper and Mongoid. Much thanks to all contributors:

* Nicolas Mérouze
* Chris Brickley
* Tony Pitale
* Nicola Racco
* Matt Powell
* Ryan Fitzgerald
* Brian Hempel

## License

Copyright (c) 2016 Tom de Bruijn  
Copyright (c) 2011-2015 Brian Hempel  
Copyright (c) 2010 Nicolas Mérouze  
Copyright (c) 2009 Chris Brickley  
Copyright (c) 2009 Tony Pitale  

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
