require "mongo"

def mongo_orm
  defined?(Mongoid) ? "mongoid" : "mongo"
end

RSpec.configure do |config|
  config.order = "random"
  config.mock_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :suite do
    Mongo::Logger.logger.level = ::Logger::INFO
  end
end
