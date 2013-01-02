source :rubygems

MONGO_VERS = '1.5.2' unless defined? MONGO_VERS

RAILS_VERS = case ENV['RAILS_VERS']
             when '3.0'
               '~>3.0.0'
             when '3.1'
               '~>3.1.0'
             when '3.2'
               '~>3.2.0'
             when nil
               nil
             else
               raise "Invalid RAILS_VERS.  Available versions are 3.0, 3.1, and 3.2."
             end

gemspec

group :development, :test do
  gem 'rake'
  if !ENV['MONGO_SESSION_STORE_ORM'] || ENV['MONGO_SESSION_STORE_ORM'] == 'mongo_mapper'
    gem 'mongo_mapper', '>= 0.10.1'
  end

  if !ENV['MONGO_SESSION_STORE_ORM'] || ENV['MONGO_SESSION_STORE_ORM'] == 'mongoid'
    # this is hack-tastic :{
    # ENV['RAILS_VERS'] is only provided when we run
    # bundle update, but not when running the specs proper
    # we need an older version of mongoid for Rails 3.0
    # and bundler won't cherry-pick a matching gem version
    # out of a git repo like it will out of the rubygems repo
    if ENV['RAILS_VERS'] == '3.0' || RUBY_VERSION[0..2] == "1.8"
      # bundle updating for Rails 3.0
      # OR we're still on Ruby 1.8
      gem 'mongoid',      '>= 2.2.5'
    elsif ENV['RAILS_VERS']
      # bundle updating for Rails 3.1 or 3.2 on Ruby 1.9
      gem 'mongoid',      '>= 2.2.5', :git => 'git://github.com/mongoid/mongoid.git'
    elsif File.read('Gemfile.lock') =~ /^    rails \(3.0.\d+\)/
      # we're running tests on Rails 3.0 on Ruby 1.9
      gem 'mongoid',      '>= 2.2.5'
    else
      # we're running tests on Rails 3.1 or 3.2 on Ruby 1.9
      gem 'mongoid',      '>= 2.2.5', :git => 'git://github.com/mongoid/mongoid.git'
    end
  end

  gem 'mongo',         MONGO_VERS
  gem 'bson_ext',      MONGO_VERS
  
  gem 'system_timer', :platforms => :ruby_18
  gem 'rbx-require-relative', '0.0.5', :platforms => :ruby_18
  gem 'ruby-debug',   :platforms => :ruby_18
  gem 'debugger',     :platforms => :ruby_19

  if RUBY_PLATFORM == 'java'
    gem 'jdbc-sqlite3'
    gem 'activerecord-jdbc-adapter'
    gem 'activerecord-jdbcsqlite3-adapter'
    gem 'jruby-openssl'
    gem 'jruby-rack'
  else
    gem 'sqlite3' # for devise User storage
  end
  RAILS_VERS ? gem('rails', RAILS_VERS) : gem('rails')
  gem 'rspec-rails'
  gem 'devise'
end