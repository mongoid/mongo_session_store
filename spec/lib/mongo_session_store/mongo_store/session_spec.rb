require "spec_helper"

if mongo_orm == "mongo"
  require "mongo_session_store"
  require "mongo_session_store/mongo_store"

  describe MongoStore::Session do
    before { described_class.collection.drop }

    describe ".database" do
      subject { described_class.database }

      context "with database" do
        let(:database) do
          MongoStore::Session.database = Mongo::Client.new(
            ["127.0.0.1:27017"],
            :database => TestDatabaseHelper.test_database_name
          )
        end
        around do |example|
          original_db = described_class.database
          described_class.database = database
          example.run
          described_class.database = original_db
        end

        it "returns the database" do
          expect(subject).to eq(database)
        end
      end

      context "without database" do
        it "raises an error" do
          original_db = described_class.database
          described_class.database = nil

          expect { subject }.to raise_error(described_class::NoMongoClientError)

          described_class.database = original_db
        end
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

    describe ".where" do
      subject { described_class.where(:_id => id) }

      context "without matching records" do
        let(:id) { nil }

        it "returns an empty array" do
          expect(subject).to eq([])
        end
      end

      context "with matching records" do
        let(:session) { described_class.new(:_id => generate_sid).tap(&:save) }
        let(:id) { session._id }
        before do
          # Noise
          described_class.new(:_id => generate_sid).tap(&:save)
        end

        it "returns session model objects" do
          expect(subject.map(&:_id)).to eq([session._id])
        end
      end
    end

    describe ".load" do
      let(:created_at) { Time.local(2016, 5, 27, 12, 25, 15) }
      let(:updated_at) { Time.local(2016, 5, 28, 16, 15, 55) }
      let(:session) { described_class.load(attributes) }

      context "without data" do
        let(:attributes) do
          {
            :_id => generate_sid,
            :created_at => created_at,
            :updated_at => updated_at
          }
        end

        it "creates a session object with empty data" do
          expect(session._id).to be_kind_of(String)
          expect(session.data).to eq({})
          expect(session.created_at).to eq(created_at)
          expect(session.updated_at).to eq(updated_at)
        end
      end

      context "with data key as a symbol" do
        let(:attributes) do
          {
            :_id => generate_sid,
            :data => BSON::Binary.new(Marshal.dump(:foo => "bar"), :generic),
            :created_at => created_at,
            :updated_at => updated_at
          }
        end

        it "creates a session object with correct data" do
          expect(session._id).to be_kind_of(String)
          expect(session.data).to eq(:foo => "bar")
          expect(session.created_at).to eq(created_at)
          expect(session.updated_at).to eq(updated_at)
        end
      end

      context "with data key as a string" do
        let(:attributes) do
          {
            :_id => generate_sid,
            "data" => BSON::Binary.new(Marshal.dump(:foo => "bar"), :generic),
            :created_at => created_at,
            :updated_at => updated_at
          }
        end

        it "creates a session object with correct data" do
          expect(session._id).to be_kind_of(String)
          expect(session.data).to eq(:foo => "bar")
          expect(session.created_at).to eq(created_at)
          expect(session.updated_at).to eq(updated_at)
        end
      end
    end

    describe "#save" do
      let(:id) { generate_sid }
      subject { described_class.collection.find(:_id => id).first }

      describe "_id attribute" do
        let(:session) { described_class.new(:_id => id) }
        before { session.save }

        it "saves a record in MongoDB" do
          expect(subject[:_id]).to eq(id)
        end
      end

      describe "timestamps" do
        let!(:time) { Time.now.utc }
        let(:session) { described_class.new(:_id => id) }

        describe "#created_at" do
          context "without time" do
            before { session.save }

            it "sets the current time" do
              expect(subject[:created_at]).to be_kind_of(Time)
              expect(subject[:created_at].to_s).to eq(time.to_s)
            end
          end

          context "with time" do
            let!(:original_created_at) { Time.parse("Thu Nov 29 14:33:20 2001").utc }
            before { session.created_at = original_created_at }

            it "keeps original created_at time" do
              expect do
                session.save
              end.to_not change { session.created_at.to_s }

              expect(subject[:created_at]).to be_kind_of(Time)
              expect(subject[:created_at].to_s).to eq(original_created_at.to_s)
            end
          end
        end

        describe "#updated_at" do
          context "without time" do
            it "sets the current time" do
              expect do
                session.save
              end.to change { session.updated_at.to_s }.from("").to(time.to_s)

              expect(subject[:updated_at]).to be_kind_of(Time)
              expect(subject[:updated_at].to_s).to eq(time.to_s)
            end
          end

          context "with time" do
            let!(:original_updated_at) { Time.parse("Thu Nov 29 14:33:20 2001").utc }
            before { session.updated_at = original_updated_at }

            it "updates the time to the current time" do
              expect do
                session.save
              end.to change { session.updated_at.to_s }.from(original_updated_at.to_s).to(time.to_s)

              expect(subject[:updated_at]).to be_kind_of(Time)
              expect(subject[:updated_at].to_s).to eq(time.to_s)
            end
          end
        end
      end

      context "with data attribute" do
        before do
          session = described_class.new(
            :_id => id,
            :data => { :foo => "bar" }
          )
          session.save
        end

        it "saves the marshalled data" do
          expect(subject[:data]).to be_kind_of(BSON::Binary)
          unmarshalled_data = Marshal.load(StringIO.new(subject[:data].data))
          expect(unmarshalled_data).to eq(:foo => "bar")
        end
      end

      context "without data attribute" do
        before do
          session = described_class.new(:_id => id)
          session.save
        end

        it "saves empty hash" do
          expect(subject[:data]).to be_kind_of(BSON::Binary)
          unmarshalled_data = Marshal.load(StringIO.new(subject[:data].data))
          expect(unmarshalled_data).to eq({})
        end
      end
    end

    describe "#destroy" do
      let(:id) { generate_sid }
      let(:session) { described_class.new(:_id => id) }
      before { session.save }

      it "removes the record from the collection" do
        expect do
          session.destroy
        end.to change { described_class.collection.count }.from(1).to(0)
        expect(described_class.collection.find(:_id => session._id).count).to eq(0)
      end
    end
  end
end
