module MongoSessionStore
  def self.collection_name
    @collection_name
  end

  def self.collection_name=(name)
    @collection_name = name

    if defined?(MongoStore::Session)
      MongoStore::Session.reset_collection
    end

    if defined?(MongoidStore::Session)
      MongoidStore::Session.store_in :collection => MongoSessionStore.collection_name
    end

    @collection_name
  end

  # default collection name for all the stores
  self.collection_name = "sessions"
end

if defined?(Mongoid)
  require "mongo_session_store/mongoid_store"
elsif defined?(Mongo)
  require "mongo_session_store/mongo_store"
end
