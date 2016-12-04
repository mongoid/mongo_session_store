require "spec_helper"

describe MongoSessionStore do
  describe ".collection_name" do
    subject { described_class.collection_name }

    it "defaults to 'sessions'" do
      expect(subject).to eq("sessions")
    end

    context "with modified collection name" do
      around do |example|
        collection_name = described_class.send :instance_variable_get, :@collection_name
        described_class.send :remove_instance_variable, :@collection_name
        example.run
        described_class.collection_name = collection_name
      end

      context "without collection name" do
        it "returns nil" do
          expect(subject).to be_nil
        end
      end

      context "with collection name" do
        before { described_class.collection_name = "foo" }

        it "returns the set collection name" do
          expect(subject).to eq("foo")
        end
      end
    end
  end

  describe ".collection_name=" do
    subject { described_class.collection_name }
    around do |example|
      collection_name = described_class.send :instance_variable_get, :@collection_name
      described_class.send :remove_instance_variable, :@collection_name
      example.run
      described_class.collection_name = collection_name
    end

    if mongo_orm == "mongoid"
      context "with mongo" do
        before { described_class.collection_name = "foo" }
        subject { MongoidStore::Session.collection.name }

        it "returns the set collection name" do
          expect(subject).to eq("foo")
        end
      end
    elsif mongo_orm == "mongo"
      context "with mongo" do
        before { described_class.collection_name = "foo" }
        subject { MongoStore::Session.collection.name }

        it "returns the set collection name" do
          expect(subject).to eq("foo")
        end
      end
    end
  end
end
