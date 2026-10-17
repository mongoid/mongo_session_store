require "spec_helper"

describe "Legacy session serialization" do
  let(:session_class) { mongo_orm == "mongoid" ? MongoidStore::Session : MongoStore::Session }

  it "reads raw marshalled strings as well as BSON binary data" do
    payload = { "nested" => { "count" => 2 }, "tags" => %w[old session] }
    session = session_class.new

    expect(session.send(:unpack, Marshal.dump(payload))).to eq(payload)
    expect(session.send(:unpack, BSON::Binary.new(Marshal.dump(payload), :generic))).to eq(payload)
  end

  it "returns nil when there is no serialized payload" do
    expect(session_class.new.send(:unpack, nil)).to be_nil
  end
end
