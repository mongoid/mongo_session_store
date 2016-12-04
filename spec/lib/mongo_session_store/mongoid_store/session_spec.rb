require "spec_helper"

if mongo_orm == "mongoid"
  require "mongo_session_store"
  require "mongo_session_store/mongoid_store"

  describe MongoidStore::Session do
    before { described_class.collection.drop }

    it "is a Mongoid model" do
      expect(subject).to be_kind_of(Mongoid::Document)
    end

    describe "#before_save" do
      let(:session) { described_class.new(attributes) }
      before do
        session.save
        session.reload
      end

      context "without data" do
        let(:attributes) { {} }

        it "saves an empty hash" do
          expect(session._data).to be_kind_of(BSON::Binary)
          expect(session.data).to eq({})
        end
      end

      context "with data" do
        let(:attributes) { { :data => { :foo => "bar" } } }

        it "saves session data as a BSON Binary" do
          expect(session._data).to be_kind_of(BSON::Binary)
          expect(session.data).to eq(:foo => "bar")
        end
      end
    end

    describe "#data" do
      let(:session) { described_class.new(:data => { "something" => "dark side" }) }

      it "returns unpacked session data" do
        expect(session.data).to eq("something" => "dark side")
      end
    end

    describe "#data=" do
      let(:session) { described_class.new }
      before { session.data = { :bar => :baz } }

      it "saves data on _data field" do
        expect(session._data).to be_kind_of(BSON::Binary)
        expect(session.data).to eq(:bar => :baz)
      end
    end

    describe "#reload" do
      it "reloads the record and reset the data attribute cache" do
        # Create record
        session = described_class.create :data => { :original => "true" }
        expect(session.data).to eq(:original => "true")

        # Update record in another object
        database_record = described_class.find(session.id)
        database_record.update_attributes!(:data => { :updated => "true" })
        expect(database_record.data).to eq(:updated => "true")

        # Reload original object
        session.reload
        # Should have updated values
        expect(session.data).to eq(:updated => "true")
      end
    end

    describe ".collection_name" do
      # Where the name comes from:
      # - "test_database" set in spec_helper
      # - "sessions" is derived from model name
      it "saves in the given collection_name" do
        expect(described_class.collection.namespace).to eq("test_database.sessions")
      end
    end
  end
end
