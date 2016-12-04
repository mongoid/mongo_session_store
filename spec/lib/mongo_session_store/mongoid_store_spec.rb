require "spec_helper"

if mongo_orm == "mongoid"
  describe MongoidStore do
    describe ".session_class" do
      subject { described_class.session_class }

      it "returns mongoid session class" do
        expect(subject).to eq(described_class::Session)
      end
    end
  end
end
