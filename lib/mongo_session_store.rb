require 'securerandom'

$:.unshift File.dirname(__FILE__)

module MongoSessionStore
  def self.collection_name=(name)
    @collection_name = name
    
    if defined?(ActionDispatch::Session::MongoStore::Session)
      ActionDispatch::Session::MongoStore::Session.reset_collection
    end

    if defined?(ActionDispatch::Session::MongoMapperStore::Session)
      ActionDispatch::Session::MongoMapperStore::Session.set_collection_name(name)
    end

    if defined?(ActionDispatch::Session::MongoidStore::Session)
      ActionDispatch::Session::MongoidStore::Session.store_in(name)
    end
  end

  def self.collection_name
    @collection_name 
  end
  
  # default collection name for all the stores
  self.collection_name = "sessions"
end

require 'mongo_session_store/mongo_mapper'
require 'mongo_session_store/mongoid'
require 'mongo_session_store/mongo'