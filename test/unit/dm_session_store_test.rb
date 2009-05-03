require File.join(File.dirname(__FILE__), "..", "test_helper")

module DataMapper
  class SessionStoreTest < Test::Unit::TestCase
    context "An instance of the SessionStore class" do
      setup do
        @session_klass = SessionStore::Session
        @session_store = SessionStore.new('app')
      end

      should "get a session" do
        env = {}
        session = stub(:data => 'data')
        @session_store.expects(:find_session).with(1).returns(session)
        assert_equal([1, 'data'], @session_store.send(:get_session, env, 1))
        assert_equal({'rack.session.record' => session}, env)
      end

      should "set a session" do
        env = {}
        session = stub
        session.expects(:data=).with({:color => 'yellow'})
        session.stubs(:save).returns(true)
        @session_store.expects(:find_session).with(1).returns(session)
        assert @session_store.send(:set_session, env, 1, {:color => 'yellow'})
        assert_equal({'rack.session.record' => session}, env)
      end

      should "find a session" do
        @session_klass.expects(:first).with(:session_id => 1).returns(nil)
        @session_klass.expects(:new).with(:session_id => 1, :data => {}).returns('session')
        assert_equal 'session', @session_store.send(:find_session, 1)
      end
    end
  end
end