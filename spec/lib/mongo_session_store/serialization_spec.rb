require "rails_helper"

describe "Session data serialization" do
  let(:session_class) { mongo_orm == "mongoid" ? MongoidStore::Session : MongoStore::Session }
  let(:id) { generate_sid }
  let(:search) { { "query" => "painting", "admin" => "1" } }
  let(:parameters) do
    values = { "search" => search }
    if Gem.loaded_specs["rails"].version >= Gem::Version.new("7.0")
      request = ActionDispatch::TestRequest.create("rack.input" => StringIO.new)
      ActionController::Parameters.new(values, :request => request)
    else
      ActionController::Parameters.new(values)
    end
  end

  it "round-trips explicitly permitted parameter values without request context" do
    record = session_class.new(:_id => id)
    record.data = { "search" => parameters.require(:search).permit(:query).to_h }
    record.save

    expect(session_class.where(:_id => id).first.data).to eq(
      "search" => { "query" => "painting" }
    )
  end

  if Gem.loaded_specs["rails"].version >= Gem::Version.new("7.0")
    it "reports serialization errors for raw parameters retaining an input stream" do
      record = session_class.new(:_id => id)
      record.data = { "search" => parameters[:search] }

      expect { record.save }.to raise_error(TypeError, /StringIO/)
      expect(session_class.collection.find(:_id => id).count).to eq(0)
    end
  end
end
