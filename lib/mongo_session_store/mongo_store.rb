require "mongo"
require "mongo_session_store/mongo_store_base"

module ActionDispatch
  module Session
    class MongoStore < MongoStoreBase
      class Session
        attr_accessor :_id, :data, :created_at, :updated_at

        def initialize(options = {})
          @_id        = options[:_id]
          @data       = options[:data]
          @created_at = options[:created_at]
          @updated_at = options[:updated_at]
        end

        def self.load(options = {})
          options[:data] = options["data"] if options["data"]
          options[:data] = unpack(options[:data])
          new(options)
        end

        def self.unpack(packed)
          return unless packed
          data = packed.respond_to?(:data) ? packed.data : packed.to_s
          Marshal.load(StringIO.new(data))
        end

        def self.where(query = {})
          collection.find(query).map { |doc| load(doc) }
        end

        def self.database
          if @database
            @database
          else
            raise "MongoStore needs a database, e.g. MongoStore::Session.database = Mongo::Client.new(['127.0.0.1:27017'], database: \"my_app_development\")"
          end
        end

        def self.database=(database)
          @database = database
        end

        def self.collection
          @collection ||= database[MongoSessionStore.collection_name]
        end

        def self.reset_collection
          @collection = nil
        end

        def collection
          self.class.collection
        end

        def scope
          collection.find(:_id => _id)
        end

        def destroy
          scope.delete_one
        end

        def save
          @created_at ||= Time.now
          @updated_at   = Time.now

          attributes = {
            :data       => pack(data),
            :created_at => @created_at,
            :updated_at => @updated_at
          }

          scope.replace_one(attributes, upsert: true)
        end

        private

        def pack(data)
          BSON::Binary.new(Marshal.dump(data), :generic)
        end

        def unpack(packed)
          self.class.unpack(packed)
        end
      end
    end
  end
end

MongoStore = ActionDispatch::Session::MongoStore
