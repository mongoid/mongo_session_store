require 'mongo_mapper'

module MongoMapper
  class SessionStore < ActionController::Session::AbstractStore
    
    class Session
      include MongoMapper::Document

      key :session_id, String, :required => true
      key :data, String, :default => [Marshal.dump({})].pack("m*")
      timestamps!
      
      #ensure each session_id is unique
      MongoMapper.ensure_index(Session, :session_id, :unique => true)
      MongoMapper.ensure_indexes!
      
    end
    
    # The class used for session storage.
    cattr_accessor :session_class
    self.session_class = Session

    SESSION_RECORD_KEY = 'rack.session.record'.freeze

    private
    def get_session(env, sid)
      sid ||= generate_sid
      session = find_session(sid)
      env[SESSION_RECORD_KEY] = session
      #[sid, session.data]
      [sid, unpack(session.data)]
    end
    
    def set_session(env, sid, session_data)
      record = env[SESSION_RECORD_KEY] ||= find_session(sid)
      record.data = pack(session_data)
      #per rack spec: Should return true or false dependant on whether or not the session was saved or not.
      record.save ? true : false
    end
    
    def find_session(id)
      @@session_class.first(:session_id => id) ||
        @@session_class.new(:session_id => id)
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
