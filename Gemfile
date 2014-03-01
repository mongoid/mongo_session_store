source 'https://rubygems.org'

RAILS_VERS = case ENV['RAILS_VERS']
             when '3.1'
               '~>3.1'
             when '3.2'
               '~>3.2'
             when '4.0'
               '~>4.0'
             when nil
               nil
             else
               raise "Invalid RAILS_VERS.  Available versions are 3.2 and 4.0."
             end

gemspec

group :development, :test do
  gem 'rake'
  if ENV['MONGO_SESSION_STORE_ORM'] == 'mongo_mapper'
    gem 'mongo_mapper', '>= 0.13.0.beta2'
  end

  if ENV['MONGO_SESSION_STORE_ORM'] == 'mongoid'
    if ENV['RAILS_VERS'] =~ /4\.\d/
      gem 'mongoid', '>= 4.0.0.beta1'
    else
      gem 'mongoid', '>= 3.1.0'
    end
  end

  if ENV['MONGO_SESSION_STORE_ORM'] == 'mongo'
    gem 'mongo'
  end

  gem 'debugger', :platforms => [:ruby_19, :ruby_20, :ruby_21] unless ENV['TRAVIS']

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

  gem 'rspec-rails', '2.12.0'
  gem 'devise'
end
