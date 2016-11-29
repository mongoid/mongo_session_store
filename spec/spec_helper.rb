require "mongo"
require "mongoid" if Gem.loaded_specs["mongoid"]
require "mongo_session_store-rails"
require "support/helpers/test_database_helper"

def mongo_orm
  defined?(Mongoid) ? "mongoid" : "mongo"
end

RSpec.configure do |config|
  config.include TestDatabaseHelper

  config.order = "random"
  config.mock_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :suite do
    Mongo::Logger.logger.level = ::Logger::INFO

    if mongo_orm == "mongoid"
      Mongoid.logger.level = Logger::INFO
      Mongoid.configure do |c|
        c.load_configuration(
          "clients" => {
            "default" => {
              "database" => TestDatabaseHelper.test_database_name,
              "hosts" => ["127.0.0.1:27017"]
            }
          }
        )
      end
    else
      MongoStore::Session.database = Mongo::Client.new(
        ["127.0.0.1:27017"],
        :database => TestDatabaseHelper.test_database_name
      )
    end
  end

  config.before do
    drop_collections_in(test_database)
  end
end
