require 'spec_helper'
require 'rails'

rails_version = Rails.version[/^\d\.\d/]
require "rails_#{rails_version}_app/config/environment"

require 'rspec/rails'

def db
  if defined?(Mongoid)
    MongoidStore::Session.mongo_session
  elsif defined?(MongoMapper)
    MongoMapper.database
  elsif defined?(Mongo)
    Mongo::Client.new(['127.0.0.1:27017'], database: database_name).database
  end
end

def database_name
  Rails.application.class.to_s.underscore.sub(/\/.*/, '') + "_" + Rails.env
end

def drop_collections_in(database)
  database.collections.select { |c| c.name !~ /^system/ }.each(&:drop)
end

RSpec.configure do |config|
  config.before :all do
    unless User.table_exists?
      load Rails.root.join('db', 'schema.rb')
    end
  end

  config.before :each do
    drop_collections_in(db)
    User.delete_all
  end
end

puts "Testing #{ENV["MONGO_SESSION_STORE_ORM"]}_store on Rails #{Rails.version}..."

case ENV["MONGO_SESSION_STORE_ORM"]
when "mongo_mapper"
  puts "MongoMapper version: #{MongoMapper::Version}"
when "mongoid"
  puts "Mongoid version: #{Mongoid::VERSION}"
end
