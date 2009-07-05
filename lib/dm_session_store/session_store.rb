require 'dm-core'

module DataMapper
  class SessionStore < ActionController::Session::AbstractStore
    class Session
      include DataMapper::Resource

      property :session_id, String, :size => 32, :nullable => false, :key => true
      property :data, Object, :default => {}, :lazy => false
      property :created_at, DateTime, :default => Proc.new { |r, p| DateTime.now }
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
      [sid, session.data]
    end

    def set_session(env, sid, session_data)
      record = env[SESSION_RECORD_KEY] ||= find_session(sid)
      record.data = nil # force dirtiness
      record.data = session_data
      record.save
    end

    def find_session(id)
      @@session_class.first(:session_id => id) ||
        @@session_class.new(:session_id => id, :data => {})
    end
  end
end
