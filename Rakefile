require "rspec/core/rake_task"

task :mongo_prepare do
  # Wait for mongod to start on Travis.
  # From the Mongo Ruby Driver gem.
  if ENV["TRAVIS"]
    require "mongo"
    client = Mongo::Client.new(["127.0.0.1:27017"])
    begin
      puts "Waiting for MongoDB..."
      client.command("ismaster" => 1)
    rescue Mongo::Error::NoServerAvailable => e
      sleep(2)
      # 1 Retry
      puts "Waiting for MongoDB..."
      client.cluster.scan!
      client.command(Mongo::Error::NoServerAvailable)
    end
  end
end

desc "Run the mongo_session_store gem test suite."
RSpec::Core::RakeTask.new :test => :mongo_prepare

task :default => :test_all
