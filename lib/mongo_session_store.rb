module MongoSessionStore
  def self.collection_name
    @collection_name
  end

  def self.collection_name=(name)
    @collection_name = name

    if defined?(MongoidStore::Session)
      MongoidStore::Session.store_in \
        :collection => MongoSessionStore.collection_name
    end

    MongoStore::Session.reset_collection if defined?(MongoStore::Session)

    @collection_name
  end
end

if defined?(Mongoid)
  require "mongo_session_store/mongoid_store"
elsif defined?(Mongo)
  require "mongo_session_store/mongo_store"
end

# Default collection name for all the stores.
MongoSessionStore.collection_name = "sessions"
