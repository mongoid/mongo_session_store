# Contributing to MongoSessionStore

## Test Environment

Start MongoDB with this script:

```text
script/testenv
```

## Testing

To run the tests for a specific store. You must first set a `BUNDLE_GEMFILE` in the environment.

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

### Docker Testing

To run tests in a Docker container with a specific Ruby version and gemfile:

```sh
BUNDLE_GEMFILE=gemfiles/rails-6.0-mongo.gemfile script/test
```

The `BUNDLE_GEMFILE` environment variable is required. Ruby version defaults to 3.4 but can be customized:

```sh
RUBY_VERSION=2.7 BUNDLE_GEMFILE=gemfiles/rails-6.0-mongo.gemfile script/test
```

## Performance Benchmark

The repository includes a performance benchmark. It runs against all available included stores and outputs the results.

```sh
bundle exec ruby perf/benchmark.rb
```

## Releases

To create a new release checkout the `master` branch and make sure it's in the right state to release. Run the `release` Rake task and follow the instructions.

```sh
bundle exec rake release
```

Run `bundle exec rake lint` on MRI Ruby 3.3 or newer to check Ruby, Markdown, YAML, and spelling, and add reviewed project vocabulary to `.spellcheck.txt`.

[mongodb]: https://www.mongodb.com/
[mongo]: https://github.com/mongodb/mongo-ruby-driver
[mongoid]: https://www.mongodb.com/docs/mongoid/current/
[rails]: https://rubyonrails.org/
[issue-rails3]: https://github.com/mongoid/mongo_session_store/issues/17
