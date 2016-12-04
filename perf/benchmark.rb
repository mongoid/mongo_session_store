require "rubygems"
require "bundler/setup"
require "benchmark"
require "action_dispatch"
require "mongoid"
require "mongo_session_store"
require "mongo_session_store/mongoid_store"
require "mongo_session_store/mongo_store"
require File.expand_path("../../lib/mongo_session_store", __FILE__)

Mongo::Logger.logger.level = Logger::FATAL
Mongoid.logger.level = Logger::FATAL

RUNS = 2000

def benchmark(test_name)
  time = Benchmark.realtime do
    RUNS.times do
      yield
    end
  end
  puts "#{(time / RUNS * 100_000).round / 100.0}ms per #{test_name}"
end

def benchmark_store(store)
  collection = store.class.session_class.collection
  collection.drop

  large_session = {
    :something => "not nothing",
    :left => "not right",
    :welcome => "not despised",
    :visits => [
      "http://www.google.com",
      "localhost:3000",
      "http://localhost:3000/increment_session",
      "http://www.iso.org/iso/country_codes/iso_3166_code_lists/iso-3166-1_decoding_table.htm",
      "http://www.geonames.org/search.html?q=2303+australia&country="
    ],
    :one_k_of_data => "a" * 1024,
    :another_k => "b" * 1024,
    :more_data => [5] * 500,
    :too_much_data_for_a_cookie => "c" * 8000,
    :a_bunch_of_floats_in_embedded_docs => [:float_a => 3.141, :float_b => -1.1] * 100
  }

  ids = []

  env = {
    "rack.session" => large_session,
    "rack.session.options" => { :id => store.send(:generate_sid) }
  }
  benchmark "session save" do
    ids << store.send(
      :set_session,
      env.merge("rack.session.options" => { :id => nil }), nil, env["rack.session"]
    )
  end

  ids.shuffle!

  benchmark "session load" do
    id = ids.pop
    local_env = { "rack.request.cookie_hash" => { "_session_id" => id } }
    _, data = store.send(:get_session, local_env, id)
    if data[:something] != "not nothing" || data[:a_bunch_of_floats_in_embedded_docs][0][:float_a] != 3.141
      puts data
      raise "saved and fetched data do not match!"
    end
  end

  database = collection.database
  stats = database.command(:collstats => collection.name).documents.first
  puts "Collection: #{collection.namespace}"
  puts "           Total Size: #{stats["size"]}"
  puts "         Object count: #{stats["count"]}"
  puts "  Average object size: #{stats["avgObjSize"]}"
  puts "          Index sizes: #{stats["indexSizes"].inspect}"
end

MongoSessionStore.collection_name = "session_collection"
MongoStore::Session.database =
  Mongo::Client.new(["127.0.0.1:27017"], :database => "mongo_test_database")
Mongoid.configure do |c|
  c.load_configuration(
    "clients" => {
      "default" => {
        "database" => "mongoid_test_database",
        "hosts" => ["127.0.0.1:27017"]
      }
    }
  )
end

puts "MongoidStore..."
mongoid_store = MongoidStore.new(nil)
benchmark_store(mongoid_store)

puts "MongoStore..."
mongo_store = MongoStore.new(nil)
benchmark_store(mongo_store)
