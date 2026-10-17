require "spec_helper"

describe "Version entry point" do
  it "defines a frozen semantic version when loaded on its own" do
    hide_const("MongoSessionStore::VERSION")
    load File.expand_path("../../../lib/mongo_session_store/version.rb", __dir__)

    expect(MongoSessionStore::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
    expect(MongoSessionStore::VERSION).to be_frozen
  ensure
    MongoSessionStore.send(:remove_const, :VERSION) if MongoSessionStore.const_defined?(:VERSION)
  end
end
