require 'mongo_mapper'

module ActionDispatch
  module Session
    class MongoMapperStore < AbstractStore

      class Session
        include MongoMapper::Document
        key :_id, String
        key :data, String, :default => [Marshal.dump({})].pack("m*")
        timestamps!
        

        ensure_index :updated_at if MongoMapper.class_variables.include? '@@database'
      end

      
      # The class used for session storage.
      cattr_accessor :session_class
      self.session_class = Session

      SESSION_RECORD_KEY = 'rack.session.record'.freeze

      private
        def generate_sid
          ActiveSupport::SecureRandom.hex(24)
        end

        def get_session(env, sid)
          sid ||= generate_sid
          session = find_session(sid)
          env[SESSION_RECORD_KEY] = session
          [sid, unpack(session.data)]
        end

        def set_session(env, sid, session_data)
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

        def destroy(env)
          if sid = current_session_id(env)
            get_session_model(env, sid).destroy
          end
        end

        def pack(data)
          [Marshal.dump(data)].pack("m*")
        end

        def unpack(packed)
          return nil unless packed
          Marshal.load(packed.unpack("m*").first)
        end

    end
  end
end
