require 'cgi'
require 'cgi/session'
require 'dm-core'

class CGI
  class Session
    attr_reader :data

    # Return this session's underlying Session instance. Useful for the DB-backed session stores.
    def model
      @dbman.model if @dbman
    end

    class DMSessionStore
      class DMSession
        include DataMapper::Resource

        storage_names[:default] = 'sessions'

        property :session_id, String, :size => 32, :nullable => false, :key => true
        property :data, Object, :default => {}, :lazy => false
        property :created_at, DateTime, :default => Proc.new { |r, p| DateTime.now }

        def self.find_by_session_id(session_id)
          first(:session_id => session_id)
        end
      end
      
      # The class used for session storage.
      cattr_accessor :session_class
      self.session_class = DMSession

      # Find or instantiate a session given a CGI::Session.
      def initialize(session, option = nil)
        session_id = session.session_id
        unless @session = @@session_class.find_by_session_id(session_id)
          unless session.new_session
            raise CGI::Session::NoSession, 'uninitialized session'
          end
          @session = @@session_class.new(:session_id => session_id, :data => {})
        end
      end

      # Access the underlying session model.
      def model
        @session
      end

      # Restore session state.  The session model handles unmarshaling.
      def restore
        if @session
          @session.data
        end
      end

      # Save session store.
      def update
        if @session
          @session.save
        end
      end

      # Save and close the session store.
      def close
        if @session
          update
          @session = nil
        end
      end

      # Delete and close the session store.
      def delete
        if @session
          @session.destroy
          @session = nil
        end
      end

      protected
        def logger
          DataMapper::Logger.new(STDERR, :fatal) rescue nil
        end
    end
  end
end
