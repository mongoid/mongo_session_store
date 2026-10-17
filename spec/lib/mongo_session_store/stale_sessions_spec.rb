require "spec_helper"

describe ".delete_stale_sessions" do
  let(:store) { mongo_orm == "mongoid" ? MongoidStore : MongoStore }
  let(:collection) { store.session_class.collection }
  let(:cutoff) { Time.utc(2026, 1, 1) }

  it "deletes only sessions last updated strictly before the cutoff" do
    collection.insert_many([
      { :_id => "stale", :updated_at => cutoff - 1 },
      { :_id => "boundary", :updated_at => cutoff },
      { :_id => "active", :created_at => cutoff - 100, :updated_at => cutoff + 1 },
      { :_id => "undated" },
      { :_id => "null-date", :updated_at => nil }
    ])

    expect(store.delete_stale_sessions(:before => cutoff)).to eq(1)
    expect(collection.find.map { |doc| doc["_id"] }.sort).to eq(
      %w[active boundary null-date undated]
    )
    expect(store.delete_stale_sessions(:before => cutoff)).to eq(0)
  end

  it "returns zero for an empty collection" do
    expect(store.delete_stale_sessions(:before => cutoff)).to eq(0)
  end

  it "accepts a cutoff with a UTC offset" do
    collection.insert_one(:_id => "stale", :updated_at => cutoff - 1)
    local_cutoff = cutoff.getlocal("-05:00")

    expect(store.delete_stale_sessions(:before => local_cutoff)).to eq(1)
    expect(local_cutoff.utc_offset).to eq(-5 * 60 * 60)
  end

  it "accepts a Rails time-zone cutoff" do
    collection.insert_one(:_id => "stale", :updated_at => cutoff - 1)
    zoned_cutoff = cutoff.in_time_zone("Eastern Time (US & Canada)")
    expect(store.delete_stale_sessions(:before => zoned_cutoff)).to eq(1)
  end

  it "rejects invalid cutoffs without deleting sessions" do
    collection.insert_one(:_id => "stale", :updated_at => cutoff - 1)

    [nil, "2026-01-01", 1].each do |value|
      expect { store.delete_stale_sessions(:before => value) }.to raise_error(
        ArgumentError, "before must be a Time"
      )
    end
    expect(collection.find.count).to eq(1)
  end

  it "uses the configured collection without touching the default collection" do
    collection.insert_one(:_id => "default", :updated_at => cutoff - 1)
    original_name = MongoSessionStore.collection_name
    begin
      MongoSessionStore.collection_name = "custom_sessions"
      custom_collection = store.session_class.collection
      custom_collection.insert_one(:_id => "custom", :updated_at => cutoff - 1)

      expect(store.delete_stale_sessions(:before => cutoff)).to eq(1)
      expect(custom_collection.find.count).to eq(0)
    ensure
      MongoSessionStore.collection_name = original_name
    end
    expect(collection.find.count).to eq(1)
  end

  it "does not suppress database errors" do
    allow(store.session_class).to receive(:collection)
      .and_raise(MongoSessionStore::Error, "unavailable")

    expect { store.delete_stale_sessions(:before => cutoff) }.to raise_error(
      MongoSessionStore::Error, "unavailable"
    )
  end
end
