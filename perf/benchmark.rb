require 'benchmark'
require 'rubygems'
require 'bundler/setup'
require 'action_dispatch'
require File.expand_path('../../lib/mongo_session_store-rails3', __FILE__)

MongoMapper.database = "test_session_stores"
# get around Mongoid's unnecessary "requires MongoDB 2.0.0" error which is NOT triggered when loading from mongo.yml!
Mongoid.config.from_hash('database' => "test_session_stores", 'logger' => false)

RUNS = 2000

def benchmark(test_name, &block)
  sleep 2 # cool off for my poor laptop
  time = Benchmark.realtime do
    RUNS.times do 
      yield
    end
  end
  puts "#{(time/RUNS*100_000).round / 100.0}ms per #{test_name}"
end

def benchmark_store(store)
  collection = store.class.session_class.collection
  collection.remove
  
  large_session =  {
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
    :one_k_of_data => "a"*1024,
    :another_k => "b"*1024,
    :more_data => [5]*500,
    :too_much_data_for_a_cookie => "c"*8000,
    :a_bunch_of_floats_in_embedded_docs => [{:float_a => 3.141, :float_b => -1.1}]*100
  }
  
  ids = []

  env = {
    'rack.session'               => large_session,
    'rack.session.options'       => { :id => store.send(:generate_sid) }
  }
  benchmark "session save" do
    id = store.send(:generate_sid)
    ids << id
    store.send(:set_session, env.merge({'rack.session.options' => { :id => id }}), id, env['rack.session'])
    # store.send(:commit_session, env.merge({'rack.session.options' => { :id => ids.last }}), 200, {}, [])
  end

  ids.shuffle!
  
  env = {
    'rack.request.cookie_string' => "",
    'HTTP_COOKIE'                => "",
    'rack.request.cookie_hash'   => { '_session_id' => store.class.session_class.last._id }
  }
  benchmark "session load" do
    id = ids.pop
    local_env = env.merge({'rack.request.cookie_hash'   => { '_session_id' => id }})
    # store.send(:prepare_session, local_env)
    sid, data = store.send(:get_session, local_env, id)
    # something = local_env['rack.session']["something"] # trigger the load
    raise data.inspect unless data[:something] == "not nothing" && data[:a_bunch_of_floats_in_embedded_docs][0] == {:float_a => 3.141, :float_b => -1.1} 
  end
  
  stats = collection.stats
  puts "           Total Size: #{stats['size']}"
  puts "         Object count: #{stats['count']}"
  puts "  Average object size: #{stats['avgObjSize']}"
  puts "          Index sizes: #{stats['indexSizes'].inspect}"
end

mongo_mapper_store = MongoMapperStore.new(nil)
mongoid_store = MongoidStore.new(nil)
mongo_store = MongoStore.new(nil)

puts "MongoMapperStore..."
benchmark_store(mongo_mapper_store)

puts "MongoidStore..."
benchmark_store(mongoid_store)

puts "MongoStore..."
benchmark_store(mongo_store)