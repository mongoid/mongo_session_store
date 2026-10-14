if ENV["COVERAGE"] == "true"
  require "simplecov"
  SimpleCov.command_name "RSpec #{Gem.loaded_specs.key?("mongoid") ? "Mongoid" : "Mongo"}"
  SimpleCov.start do
    track_files "lib/**/*.rb"
    add_filter "/spec/"
  end
end

require "logger"
require "mongo"
require "mongoid" if Gem.loaded_specs["mongoid"]
require "mongo_session_store"
require "support/helpers/test_database_helper"
require "support/helpers/session_id_helper"

def mongo_orm
  defined?(Mongoid) ? "mongoid" : "mongo"
end

case mongo_orm
when "mongo"
  require "mongo_session_store/mongo_store"
when "mongoid"
  require "mongo_session_store/mongoid_store"
end

RSpec.configure do |config|
  config.include TestDatabaseHelper
  config.include SessionIdHelper

  config.order = "random"
  config.mock_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :suite do
    Mongo::Logger.logger.level = ::Logger::INFO

    mongodb_host = ENV["MONGODB_HOST"] || "127.0.0.1"
    mongodb_port = ENV["MONGODB_PORT"] || "27017"
    if mongo_orm == "mongoid"
      Mongoid.logger.level = Logger::INFO
      Mongoid.configure do |c|
        c.load_configuration(
          "clients" => {
            "default" => {
              "database" => TestDatabaseHelper.test_database_name,
              "hosts" => ["#{mongodb_host}:#{mongodb_port}"]
            }
          }
        )
      end
    else
      MongoStore::Session.database = Mongo::Client.new(
        ["#{mongodb_host}:#{mongodb_port}"],
        :database => TestDatabaseHelper.test_database_name
      )
    end
  end

  config.before do
    drop_collections_in(test_database)
  end
end
