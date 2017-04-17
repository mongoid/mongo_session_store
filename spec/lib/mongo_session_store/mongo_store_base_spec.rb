require "spec_helper"
require "ostruct"

class TestStore < ActionDispatch::Session::MongoStoreBase
  class Session < OpenStruct
    def self.where(_ = {})
      []
    end
  end
end

describe ActionDispatch::Session::MongoStoreBase do
  describe ".session_class" do
    let(:store_class) { TestStore }
    let(:store) { store_class.new(nil) }
    subject { store_class.session_class }

    it "returns child session class" do
      expect(subject).to eq(TestStore::Session)
    end
  end

  describe "#get_session" do
    let(:env) { {} }
    let(:store_class) { TestStore }
    let(:store) { store_class.new(nil) }
    let(:session_class) { store_class::Session }
    let(:session_record) { env[store_class::SESSION_RECORD_KEY] }

    context "when no session exists" do
      it "creates a new session" do
        sid, session_data = store.send(:get_session, env, nil)

        expect(sid).to be_kind_of(String)
        expect(session_data).to be_nil
        expect(session_record).to be_kind_of(session_class)
        expect(session_record._id).to eq sid

        env_record = env[described_class::SESSION_RECORD_KEY]
        expect(env_record).to be_kind_of(session_class)
        expect(env_record._id).to eq sid
      end
    end

    context "when given session is found" do
      let(:session) { session_class.new(:_id => "foo", :data => nil) }
      before do
        expect(session_class).to receive(:where).and_return([session])
      end

      it "returns the existing session" do
        sid, session_data = store.send(:get_session, env, session._id)

        expect(sid).to eq(session._id)
        expect(sid).to be_kind_of(String)
        expect(session_data).to be_nil
        expect(session_record).to be_kind_of(session_class)
        expect(session_record._id).to eq sid

        env_record = env[described_class::SESSION_RECORD_KEY]
        expect(env_record).to be_kind_of(session_class)
        expect(env_record._id).to eq sid
      end
    end

    context "when given session is not found" do
      let(:not_existing_session_id) { SecureRandom.hex }

      it "creates a new session" do
        sid, session_data = store.send(:get_session, env, not_existing_session_id)

        expect(sid).to_not eq(not_existing_session_id)
        expect(sid).to be_kind_of(String)
        expect(session_data).to be_nil
        expect(session_record).to be_kind_of(session_class)
        expect(session_record._id).to eq sid

        env_record = env[described_class::SESSION_RECORD_KEY]
        expect(env_record).to be_kind_of(session_class)
        expect(env_record._id).to eq sid
      end
    end

    context "with custom session class" do
      let(:store_class) { TestStore }

      it "returns a session record from the custom session class" do
        sid, session_data = store.send(:get_session, env, nil)

        expect(sid).to be_kind_of(String)
        expect(session_data).to be_nil
        expect(session_record).to be_kind_of(session_class)
        expect(session_record._id.to_s).to eq sid
      end
    end
  end

  describe "#set_session" do
    let(:store_class) { mongo_orm == "mongoid" ? MongoidStore : MongoStore }
    let(:store) { store_class.new(nil) }
    let(:session_class) { store_class::Session }
    subject { store.send(:set_session, env, generate_sid, {}) }

    context "with existing session record" do
      let(:id) { generate_sid }
      let!(:session_record) { session_class.new(:_id => id).tap(&:save) }
      let(:env) do
        {
          "rack.session" => double(:id => id),
          Rack::Session::Abstract::ENV_SESSION_OPTIONS_KEY => { :id => id }
        }
      end
      subject { store.send(:set_session, env, id, {}) }

      it "uses the existing record" do
        expect do
          subject
        end.to_not change { session_class.collection.find(:_id => id).count }
        expect(subject).to eq(id.to_s)
      end

      it "yields" do
        yielded_variable = :not_called
        block =
          proc do
            yielded_variable = :called
          end
        store.send(:set_session, env, id, {}, &block)
        expect(yielded_variable).to eq(:called)
      end

      context "with session record in the ENV" do
        let(:env) do
          {
            "rack.session" => double(:id => id),
            Rack::Session::Abstract::ENV_SESSION_OPTIONS_KEY => { :id => id },
            "rack.session.record" => session_record
          }
        end

        it "uses the record from the ENV" do
          expect do
            expect(session_record).to receive(:data=).and_call_original
            subject
          end.to_not change { session_class.collection.find(:_id => id).count }
        end
      end
    end

    context "without existing session record" do
      let :env do
        {
          "rack.session" => {},
          Rack::Session::Abstract::ENV_SESSION_OPTIONS_KEY => {}
        }
      end

      it "creates a session record" do
        expect do
          subject
        end.to change { session_class.collection.find.count }.from(0).to(1)
        expect(subject).to be_kind_of(String)
      end

      it "sets the session record in the env" do
        sid = subject
        expect(env["rack.session.record"]).to be_kind_of(session_class)
        expect(env["rack.session.record"]._id.to_s).to eq(sid)
      end

      context "when not saved" do
        before do
          record = double("data=" => nil, :save => false)
          expect(store).to receive(:get_session_record).and_return([1, record])
        end

        it "returns false" do
          expect(subject).to be false
        end
      end
    end
  end

  describe "#destroy_session" do
    let(:id) { generate_sid }
    let(:store_class) { mongo_orm == "mongoid" ? MongoidStore : MongoStore }
    let(:store) { store_class.new(nil) }
    let(:session_class) { store_class::Session }
    let(:env) do
      {
        "rack.session" => double(:id => id),
        Rack::Session::Abstract::ENV_SESSION_OPTIONS_KEY => {}
      }
    end

    context "without existing session" do
      subject { store.send(:destroy_session, env, id, {}) }

      it "does not remove any record" do
        expect { subject }.to_not change { session_class.collection.count }
      end

      it "returns new session id" do
        expect(subject).to be_kind_of(String)
        expect(subject).to_not eq(id)
      end

      context "with option :drop" do
        subject { store.send(:destroy_session, env, id, :drop => true) }

        it "does not remove any record" do
          expect { subject }.to_not change { session_class.collection.count }
        end

        it "returns nothing" do
          expect(subject).to be_nil
        end
      end
    end

    context "with existing session" do
      let!(:session_record) { session_class.new(:_id => id).tap(&:save) }
      subject { store.send(:destroy_session, env, id, {}) }

      it "removes the session record" do
        expect do
          subject
        end.to change { session_class.collection.find(:_id => id).count }.from(1).to(0)
      end

      it "returns new session id" do
        expect(subject).to be_kind_of(String)
        expect(subject).to_not eq(session_record._id)
      end

      context "with session record in the ENV" do
        let(:env) do
          {
            "rack.session" => double(:id => id),
            Rack::Session::Abstract::ENV_SESSION_OPTIONS_KEY => { :id => id },
            "rack.session.record" => session_record
          }
        end
        subject { store.send(:destroy_session, env, id, :drop => true) }

        it "destroys record in the env" do
          expect do
            expect(session_record).to receive(:destroy).and_call_original
            subject
          end.to change { session_class.collection.find(:_id => id).count }.from(1).to(0)
        end
      end

      context "with option :drop" do
        subject { store.send(:destroy_session, env, id, :drop => true) }

        it "removes the session record" do
          expect do
            subject
          end.to change { session_class.collection.find(:_id => id).count }.from(1).to(0)
        end

        it "returns nothing" do
          expect(subject).to be_nil
        end
      end
    end
  end
end
