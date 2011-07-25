require 'rubygems'
require 'rake'

def run_with_output(command)
  puts "Running: #{command}"
  
  Process.wait( fork { exec command } )
end

def set_rails_version(rails_vers)
  unless File.exists?("Gemfile_Rails_#{rails_vers}.lock")
    run_with_output "export RAILS_VERS=#{rails_vers}; bundle update rails"
    run_with_output "cp Gemfile.lock Gemfile_Rails_#{rails_vers}.lock"
  else
    run_with_output "rm Gemfile.lock"
    run_with_output "cp Gemfile_Rails_#{rails_vers}.lock Gemfile.lock"    
  end
end

task :default => :test_all

desc 'Test each session store against Rails 3.0 and Rails 3.1'
task :test_all do
  # inspired by http://pivotallabs.com/users/jdean/blog/articles/1728-testing-your-gem-against-multiple-rubies-and-rails-versions-with-rvm
  
  orms = ['mongo_mapper', 'mongoid']
  
  set_rails_version('3.0')
  
  orms.each do |orm|
    run_with_output "export MONGO_SESSION_STORE_ORM=#{orm}; bundle exec rspec spec"
  end

  set_rails_version('3.1')
  
  orms.each do |orm|
    run_with_output "export MONGO_SESSION_STORE_ORM=#{orm}; bundle exec rspec spec"
  end
end

desc 'Set Rails version to 3.0'
task :use_rails_30 do
  set_rails_version('3.0')
end

desc 'Set Rails version to 3.1'
task :use_rails_31 do
  set_rails_version('3.1')
end