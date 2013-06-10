require 'securerandom'

$:.unshift File.dirname(__FILE__)

module MongoSessionStore
  autoload :VERSION, 'mongo_session_store/version'

  def self.collection_name=(name)
    @collection_name = name
    
    if defined?(MongoStore::Session)
      MongoStore::Session.reset_collection
    end

    if defined?(MongoMapperStore::Session)
      MongoMapperStore::Session.set_collection_name(name)
    end

    if defined?(MongoidStore::Session)

      MongoidStore::Session.store_in :collection => MongoSessionStore.collection_name
    end

    @collection_name
  end

  def self.collection_name
    @collection_name 
  end
  
  # default collection name for all the stores
  self.collection_name = "sessions"
end

# we don't use autoloading because of thread concerns
# hence, this mess
load_errors = []

%w(mongo_mapper_store mongoid_store mongo_store).each do |store_name|
  begin
    require "mongo_session_store/#{store_name}"
  rescue LoadError => e
    load_errors << e
  end
end

if load_errors.count == 3
  message = "Could not load any session store!\n" + load_errors.map(&:message).join("\n")
  raise LoadError, message
end
