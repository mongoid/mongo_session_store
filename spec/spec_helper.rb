ENV["MONGO_SESSION_STORE_ORM"] ||= "mongo_mapper"
ENV["RAILS_ENV"] = "test"

$:.unshift File.dirname(__FILE__)

require 'rails'

rails_version = Rails.version[/^\d\.\d/]
require "rails_#{rails_version}_app/config/environment"

require 'rspec/rails'

def db
  Mongo::Connection.new[database_name]
end

def database_name
  Rails.application.class.to_s.underscore.sub(/\/.*/, '') + "_" + Rails.env
end

def drop_collections_in(database)
  database.collections.select { |c| c.name !~ /^system/ }.each(&:drop)
end

RSpec.configure do |config|
  config.before :each do
    drop_collections_in(Mongoid.database) if defined?(Mongoid)
    drop_collections_in(MongoMapper.database) if defined?(MongoMapper)
    drop_collections_in(db)
  end
end

puts "Testing #{ENV["MONGO_SESSION_STORE_ORM"]}_store on Rails #{Rails.version}..."