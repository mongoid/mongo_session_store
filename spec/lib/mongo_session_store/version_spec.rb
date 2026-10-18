require "spec_helper"

describe MongoSessionStore do
  it "defines a frozen semantic version" do
    expect(MongoSessionStore::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
    expect(MongoSessionStore::VERSION).to be_frozen
  end
end
