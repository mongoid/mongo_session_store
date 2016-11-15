require "mongoid"
require "mongo_session_store/mongo_store_base"

module ActionDispatch
  module Session
    class MongoidStore < MongoStoreBase
      BINARY_CLASS = defined?(Moped::BSON::Binary) ? Moped::BSON::Binary : BSON::Binary

      class Session
        include Mongoid::Document
        include Mongoid::Timestamps

        attr_writer :data

        store_in :collection => MongoSessionStore.collection_name

        field :_data, :type => BINARY_CLASS, :default => -> { pack({}) }

        def data
          @data ||= unpack(self._data)
        end

        def self.pack(data)
          if BINARY_CLASS.to_s == "BSON::Binary"
            BSON::Binary.new(Marshal.dump(data), :generic)
          else
            Moped::BSON::Binary.new(:generic, Marshal.dump(data))
          end
        end

        private

        before_save do
          self._data = pack(data)
        end

        def pack(data)
          self.class.pack(data)
        end

        def unpack(packed)
          return unless packed
          if packed.respond_to? :data
            Marshal.load(packed.data)
          else
            Marshal.load(packed.to_s)
          end
        end
      end
    end
  end
end

MongoidStore = ActionDispatch::Session::MongoidStore
