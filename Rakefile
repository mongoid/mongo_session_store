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

task :release do
  GEMSPEC_NAME = "mongo_session_store"
  GEM_NAME = "mongo_session_store-rails"
  VERSION_FILE = "lib/mongo_session_store/version.rb"

  def reload_version
    if defined?(MongoSessionStore::VERSION)
      MongoSessionStore.send(:remove_const, :VERSION)
    end
    load File.expand_path(VERSION_FILE)
  end

  raise "$EDITOR should be set" unless ENV["EDITOR"]

  def build_and_push_gem
    puts '# Building gem'
    puts `gem build #{GEMSPEC_NAME}.gemspec`
    puts '# Publishing Gem'
    puts `gem push #{GEM_NAME}-#{gem_version}.gem`
  end

  def update_repo
    puts `git commit -am "Bump to #{version} [ci skip]"`
    begin
      puts `git tag #{version}`
      puts `git push origin #{version}`
      puts `git push origin master`
    rescue
      raise %(Tag: "#{version}" already exists)
    end
  end

  def changes
    git_status_to_array(`git status -s -u`)
  end

  def gem_version
    MongoSessionStore::VERSION
  end

  def version
    @version ||= "v" << gem_version
  end

  def git_status_to_array(changes)
    changes.split("\n").map { |change| change.gsub(/^.. /, "") }
  end

  raise "Branch should hold no uncommitted file change)" unless changes.empty?

  reload_version

  system("$EDITOR #{VERSION_FILE}")
  if changes.include?(VERSION_FILE)
    reload_version
    build_and_push_gem
    update_repo
  else
    raise "Actually change the version in: #{VERSION_FILE}"
  end
end

task :default => :test
