require 'mongo'

module ActionDispatch
  module Session
    class MongoStore < AbstractStore

      class Session
        attr_accessor :_id, :data, :created_at, :updated_at
        
        def initialize(options={})
          @_id        = options[:_id]
          @data       = options[:data]
          @created_at = options[:created_at]
          @updated_at = options[:updated_at]
        end
        
        def self.load(options={})
          options[:data] = options["data"].to_s if options["data"]
          new(options)
        end
        
        def destroy
          collection.remove :_id => _id
        end
        
        def save
          @created_at ||= Time.now
          @updated_at   = Time.now
          
          collection.save(
            :_id        => @_id,
            :data       => BSON::Binary.new(@data),
            :created_at => @created_at,
            :updated_at => @updated_at
          )
        end
        
        def data=(stuff)
          @data = stuff.to_s
        end
        
        def self.where(query = {})
          collection.find(query).map { |doc| load(doc) }
        end
        
        def self.last
          where.last
        end
        
        def self.database
          if @database
            @database
          elsif defined?(MongoMapper)
            MongoMapper.database
          elsif defined?(Mongoid)
            Mongoid.database
          else
            raise "MongoStore needs a database, e.g. #{name.to_s}.database = Mongo::Connection.new.db('my_app_development')"
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
      end

      
      # The class used for session storage.
      cattr_accessor :session_class
      self.session_class = Session

      SESSION_RECORD_KEY = 'rack.session.record'.freeze
      begin
        ENV_SESSION_OPTIONS_KEY = Rack::Session::Abstract::ENV_SESSION_OPTIONS_KEY
      rescue NameError
        # Rack 1.2.x has access to the ENV_SESSION_OPTIONS_KEY
      end

      private
        def generate_sid
          # 20 random bytes in url-safe base64
          SecureRandom.base64(20).gsub('=','').gsub('+','-').gsub('/','_')
        end

        def get_session(env, sid)
          sid ||= generate_sid
          session = find_session(sid)
          env[SESSION_RECORD_KEY] = session
          [sid, unpack(session.data)]
        end

        def set_session(env, sid, session_data, options = {})
          record = get_session_model(env, sid)
          record.data = pack(session_data)
          # Rack spec dictates that set_session should return true or false
          # depending on whether or not the session was saved or not.
          # However, ActionPack seems to want a session id instead.
          record.save ? sid : false
        end

        def find_session(id)
          @@session_class.where(:_id => id).first || @@session_class.new(:_id => id)
        end

        def get_session_model(env, sid)
          if env[ENV_SESSION_OPTIONS_KEY][:id].nil?
            env[SESSION_RECORD_KEY] = find_session(sid)
          else
            env[SESSION_RECORD_KEY] ||= find_session(sid)
          end
        end

        def destroy_session(env, session_id, options)
          if sid = current_session_id(env)
            get_session_model(env, sid).destroy
            env[SESSION_RECORD_KEY] = nil
          end

          generate_sid unless options[:drop]
        end

        def pack(data)
          Marshal.dump(data)
        end

        def unpack(packed)
          return nil unless packed
          Marshal.load(StringIO.new(packed.to_s))
        end

    end
  end
end
