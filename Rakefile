require 'rubygems'
require 'rake'
require 'bundler'
Bundler::GemHelper.install_tasks

def run_with_output(command)
  puts "Running: #{command}"
  system(command)
end

def set_rails_version(rails_vers)
  unless File.exists?("Gemfile_Rails_#{rails_vers}.lock")
    run_with_output "export RAILS_VERS=#{rails_vers}; bundle update"
    run_with_output "cp Gemfile.lock Gemfile_Rails_#{rails_vers}.lock"
  else
    run_with_output "rm Gemfile.lock"
    run_with_output "cp Gemfile_Rails_#{rails_vers}.lock Gemfile.lock"    
  end
end

@rails_versions = ['3.1', '3.2']

task :default => :test_all

desc 'Test each session store against Rails 3.1 and Rails 3.2'
task :test_all do
  # inspired by http://pivotallabs.com/users/jdean/blog/articles/1728-testing-your-gem-against-multiple-rubies-and-rails-versions-with-rvm

  orms = ['mongo_mapper', 'mongoid', 'mongo']
  orms.delete('mongoid') if RUBY_VERSION < "1.9"

  @failed_suites = []

  @rails_versions.each do |rails_version|

    set_rails_version(rails_version)
  
    orms.each do |orm|
      unless run_with_output "export MONGO_SESSION_STORE_ORM=#{orm}; bundle exec rspec spec"
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

  desc "Set Rails version to #{rails_version}"
  task :"use_rails_#{rails_version.gsub('.', '')}" do
    set_rails_version(rails_version)
  end

end