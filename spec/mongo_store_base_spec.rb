require 'spec_helper'
require 'securerandom'
require 'ostruct'
require 'mongo_session_store/mongo_store_base'

describe ActionDispatch::Session::MongoStoreBase do
  ENV_SESSION_OPTIONS_KEY = ActionDispatch::Session::MongoStoreBase::ENV_SESSION_OPTIONS_KEY
  SESSION_RECORD_KEY      = ActionDispatch::Session::MongoStoreBase::SESSION_RECORD_KEY

  Session = ActionDispatch::Session::MongoStoreBase::Session = Class.new(OpenStruct)

  before do
    @app   = nil
    @store = ActionDispatch::Session::MongoStoreBase.new(@app)
    @env   = {}
  end

  describe "#get_session" do
    it "generates a new session id if given a nil session id" do
      Session.stub(where: [])

      sid, session_data = @store.send(:get_session, @env, nil)

      sid.should_not                        == nil
      session_data.should                   == nil
      @env[SESSION_RECORD_KEY].class.should == Session
      @env[SESSION_RECORD_KEY]._id.should   == sid
    end

    it "generates a new session id if session is not found" do
      old_sid = SecureRandom.hex
      Session.stub(where: [])

      sid, session_data = @store.send(:get_session, @env, old_sid)

      sid.should_not                        == old_sid
      session_data.should                   == nil
      @env[SESSION_RECORD_KEY].class.should == Session
      @env[SESSION_RECORD_KEY]._id.should   == sid
    end
  end
end
