require "rspec/core/rake_task"

desc "Prepare MongoDB connection"
task :mongo_prepare do
  # Wait for mongod to start on Travis.
  # From the Mongo Ruby Driver gem.
  if ENV["TRAVIS"]
    require "mongo"
    client = Mongo::Client.new(["127.0.0.1:27017"])
    begin
      puts "Waiting for MongoDB..."
      client.command("ismaster" => 1)
    rescue Mongo::Error::NoServerAvailable
      sleep 2
      # 1 Retry
      puts "Waiting for MongoDB..."
      client.cluster.scan!
      client.command(Mongo::Error::NoServerAvailable)
    end
  end
end

desc "Run the mongo_session_store gem test suite."
RSpec::Core::RakeTask.new :test => :mongo_prepare

require "bundler/gem_tasks"

if RUBY_ENGINE == "ruby" && Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.3") &&
   Gem.loaded_specs.key?("ruby-gem-release")
  require_relative "script/release"
  MongoSessionStoreRelease.workflow.install_tasks

  %w[release release:rubygem_push release:source_control_push].each do |name|
    Rake::Task[name].clear
    desc "Disabled; releases run through GitHub Actions, see RELEASING.md"
    task(name) { abort "#{name} is disabled; releases run through GitHub Actions, see RELEASING.md" }
  end
end

lint = RUBY_ENGINE == "ruby" && Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.3") &&
       Gem.loaded_specs.key?("rubocop")
if lint
  require "rubocop/rake_task"
  RuboCop::RakeTask.new(:rubocop)

  desc "Lint Ruby, Markdown, YAML, and spelling"
  task :lint => :rubocop
end

desc "Default task for Rake. Runs lint, where available, and the test suite."
task :default => (lint ? [:rubocop, :test] : [:test])
