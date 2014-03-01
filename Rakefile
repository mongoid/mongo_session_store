require 'rubygems'
require 'rake'
require 'bundler'
Bundler::GemHelper.install_tasks

def run_with_output(command)
  puts "Running: #{command}"
  system(command)
end

def set_versions(rails_vers, orm)
  success = true
  unless File.exists?("Gemfile_Rails_#{rails_vers}_#{orm}_#{RUBY_VERSION}.lock")
    success &&= run_with_output("export RAILS_VERS=#{rails_vers}; export MONGO_SESSION_STORE_ORM=#{orm}; bundle update")
    success &&= run_with_output("cp Gemfile.lock Gemfile_Rails_#{rails_vers}_#{orm}_#{RUBY_VERSION}.lock")
  else
    success &&= run_with_output("rm Gemfile.lock")
    success &&= run_with_output("cp Gemfile_Rails_#{rails_vers}_#{orm}_#{RUBY_VERSION}.lock Gemfile.lock")
  end
  success
end

@rails_versions = ['3.1', '3.2', '4.0']
@orms = ['mongo_mapper', 'mongoid', 'mongo']

task :default => :test_all

desc 'Test each session store against Rails 3.1, 3.2, and 4.0'
task :test_all do
  # inspired by http://pivotallabs.com/users/jdean/blog/articles/1728-testing-your-gem-against-multiple-rubies-and-rails-versions-with-rvm


  @failed_suites = []

  @rails_versions.each do |rails_version|
    @orms.each do |orm|
      success = set_versions(rails_version, orm)

      unless success && run_with_output("export RAILS_VERS=#{rails_version}; export MONGO_SESSION_STORE_ORM=#{orm}; bundle exec rspec spec")
        @failed_suites << "Rails #{rails_version} / #{orm}"
      end
    end
  end

  if @failed_suites.any?
    puts "\033[0;31mFailed:"
    puts @failed_suites.join("\n")
    print "\033[0m"
    exit(1)
  else
    print "\033[0;32mAll passed! Success! "
    "Yahoooo!!!".chars.each { |c| sleep 0.4; print c; STDOUT.flush }
    puts "\033[0m"
  end
end

@rails_versions.each do |rails_version|
  @orms.each do |orm|
    desc "Set Rails version to #{rails_version} with #{orm}"
    task :"use_#{rails_version.gsub('.', '')}_#{orm}" do
      set_versions(rails_version, orm)
    end

    desc "Rebundle for #{rails_version} with #{orm}"
    task :"rebundle_#{rails_version.gsub('.', '')}_#{orm}" do
      run_with_output "rm Gemfile_Rails_#{rails_version}_#{orm}_#{RUBY_VERSION}.lock Gemfile.lock"
      set_versions(rails_version, orm)
    end
  end
end