require "mongo_session_store/mongo_store_base"

module ActionDispatch
  module Session
    class MongoStore < MongoStoreBase
      class Session
        class << self
          attr_writer :database

          def load(options = {})
            options[:data] = options["data"] if options["data"]
            options[:data] =
              if options[:data]
                unpack(options[:data])
              else
                {}
              end
            new(options)
          end

          def where(query = {})
            collection.find(query).map { |doc| load(doc) }
          end

          def database
            return @database if @database

            raise NoMongoClientError, "MongoStore needs a database, e.g. "\
              "MongoStore::Session.database = Mongo::Client.new("\
              "[\"127.0.0.1:27017\"], database: \"my_app_development\")"
          end

          def collection
            @collection ||= database[MongoSessionStore.collection_name]
          end

          def reset_collection
            @collection = nil
          end

          private

          def unpack(packed)
            return unless packed
            data = packed.respond_to?(:data) ? packed.data : packed.to_s
            Marshal.load(StringIO.new(data))
          end
        end

        class NoMongoClientError < StandardError; end

        attr_accessor :_id, :data, :created_at, :updated_at

        def initialize(options = {})
          @_id        = options[:_id]
          @data       = options[:data]
          @created_at = options[:created_at]
          @updated_at = options[:updated_at]
        end

        def save
          @created_at ||= Time.now.utc
          @updated_at = Time.now.utc

          scope.replace_one(attributes_for_save, :upsert => true)
        end

        def destroy
          scope.delete_one
        end

        private

        def collection
          self.class.collection
        end

        def attributes_for_save
          {
            :data => pack(data),
            :created_at => created_at,
            :updated_at => updated_at
          }
        end

        def scope
          collection.find(:_id => _id)
        end

        def pack(data)
          BSON::Binary.new(Marshal.dump(data || {}), :generic)
        end

        def unpack(packed)
          self.class.unpack(packed)
        end
      end
    end
  end
end

MongoStore = ActionDispatch::Session::MongoStore
