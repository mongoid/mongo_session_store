require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'cgi'
require 'cgi/session'

class CGI
  class Session

    class DMSessionStoreTest < Test::Unit::TestCase
      context "The DMSessionStore initialize method" do
        should "raise CGI:Session::NoSession if session is not a new_session" do
          DMSessionStore::DMSession.stubs(:find_by_session_id).with("1").returns(nil)
          session = DMSessionStore::DMSession.new(:session_id => "1")
          session.stubs(:new_session).with().returns(false)
          assert_raise CGI::Session::NoSession, "uninitialized session" do
            DMSessionStore.new(session)
          end
        end
      end

      context "An instance of the DMSessionStore class" do
        setup do
          @session = DMSessionStore::DMSession.new(:session_id => "1", :data => {:hello => 'world'})
          DMSessionStore::DMSession.stubs(:find_by_session_id).with("1").returns(nil)
          old_session = DMSessionStore::DMSession.new(:session_id => "1")
          old_session.stubs(:new_session).with().returns(true)
          DMSessionStore::DMSession.stubs(:new).with(:session_id => "1", :data => {}).returns(@session)
          @session_store = DMSessionStore.new(old_session)
        end

        should "have the session" do
          assert_equal @session, @session_store.model
        end

        should "return the data from session" do
          assert_equal({:hello => 'world'}, @session_store.restore)
        end

        should "save the session" do
          @session.expects(:save).with().returns(true)
          assert_equal true, @session_store.update
        end

        should "save and unreference the session" do
          @session_store.expects(:update)
          @session_store.close
          assert_equal nil, @session_store.model
        end

        should "destroy and unreference the session" do
          @session.expects(:destroy)
          @session_store.delete
          assert_equal nil, @session_store.model
        end

        should "log with DataMapper" do
          DataMapper::Logger.expects(:new).with(STDERR, :fatal).returns('logger')
          assert_equal 'logger', @session_store.send(:logger)
        end
      end
    end
  end
end