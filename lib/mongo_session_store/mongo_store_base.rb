require "action_dispatch/middleware/session/abstract_store"

module ActionDispatch
  module Session
    class MongoStoreBase < AbstractStore
      SESSION_RECORD_KEY = "rack.session.record".freeze
      ENV_SESSION_OPTIONS_KEY = Rack::Session::Abstract::ENV_SESSION_OPTIONS_KEY

      def self.session_class
        self::Session
      end

      private

      def session_class
        self.class.session_class
      end

      def get_session(env, sid)
        id, record = find_or_initialize_session(sid)
        env[SESSION_RECORD_KEY] = record
        [id, record.data]
      end

      def set_session(env, sid, session_data, _options = {})
        id, record = get_session_record(env, sid)
        record.data = session_data
        yield if block_given?
        # Rack spec dictates that set_session should return true or false
        # depending on whether or not the session was saved or not.
        # However, ActionPack seems to want a session id instead.
        record.save ? id : false
      end

      def find_or_initialize_session(id)
        existing_session = (id && session_class.where(:_id => id).first)
        session = existing_session if existing_session
        session ||= session_class.new(:_id => generate_sid)
        [session._id, session]
      end

      def get_session_record(env, sid)
        if env[ENV_SESSION_OPTIONS_KEY][:id].nil? || !env[SESSION_RECORD_KEY]
          sid, env[SESSION_RECORD_KEY] = find_or_initialize_session(sid)
        end

        [sid, env[SESSION_RECORD_KEY]]
      end

      def destroy_session(env, _session_id, options)
        destroy(env)
        generate_sid unless options[:drop]
      end

      def destroy(env)
        sid = current_session_id(env)
        return unless sid

        _, record = get_session_record(env, sid)
        record.destroy
        env[SESSION_RECORD_KEY] = nil
      end
    end
  end
end
