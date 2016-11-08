require "spec_helper"
require "ostruct"

describe ActionDispatch::Session::MongoStoreBase do
  Session = ActionDispatch::Session::MongoStoreBase::Session = Class.new(OpenStruct) do
    def self.where(_ = {})
      []
    end
  end

  let(:store) { ActionDispatch::Session::MongoStoreBase.new(nil) }
  let(:env) { {} }
  let(:session_record) { env[ActionDispatch::Session::MongoStoreBase::SESSION_RECORD_KEY] }

  describe "#get_session" do
    context "when no session exists" do
      it "creates a new session" do
        sid, session_data = store.send(:get_session, env, nil)

        expect(sid).to be_kind_of(String)
        expect(session_data).to be_nil
        expect(session_record.class).to eq Session
        expect(session_record._id).to eq sid
      end
    end

    context "when given session id is not found" do
      let(:not_existing_session_id) { SecureRandom.hex }

      it "creates a new session" do
        sid, session_data = store.send(:get_session, env, not_existing_session_id)

        expect(sid).to_not eq(not_existing_session_id)
        expect(sid).to be_kind_of(String)
        expect(session_data).to be_nil
        expect(session_record.class).to eq Session
        expect(session_record._id).to eq sid
      end
    end
  end
end
