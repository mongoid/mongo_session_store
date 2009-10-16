require 'mongo_mapper'

module MongoMapper
  class SessionStore < ActionController::Session::AbstractStore
    class Session
      include MongoMapper::Document

      key :session_id, String, :required => true#, :key => true
      #key :data, Hash, :default => {}
      key :data, String
      timestamps!
      
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
      record.data = nil # force dirtiness
      record.data = pack(session_data)
      record.save
      true
    end
    
    def find_session(id)
      @@session_class.first(:session_id => id) ||
        @@session_class.new(:session_id => id, :data => pack({}))
    end
    
    def pack(session)
      [Marshal.dump(session)].pack("m*")
    end

    def unpack(packed)
      return nil unless packed
      Marshal.load(packed.unpack("m*").first)
    end
    
  end
end
