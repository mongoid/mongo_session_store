source 'https://rubygems.org'

RAILS_VERS = case ENV['RAILS_VERS']
             when '3.1'
               '~>3.1.12'
             when '3.2'
               '~>3.2.18'
             when '4.0'
               '~>4.0.5'
             when '4.1'
               '~>4.1.9'
             when '4.2'
               '~>4.2.0'
             when nil
               nil
             else
               raise "Invalid RAILS_VERS.  Available versions are 3.1, 3.2, 4.0, 4.1, and 4.2."
             end

gemspec :name => 'mongo_session_store-rails4'

group :development, :test do
  gem 'rake'

  case ENV['MONGO_SESSION_STORE_ORM']
  when 'mongo_mapper'
    gem 'mongo_mapper', '>= 0.13.1'
  when 'mongoid'
    if ENV['RAILS_VERS'] =~ /^4\.\d/
      gem 'mongoid', '>= 4.0.2'
    elsif ENV['RAILS_VERS'] =~ /^3\.2\d/
      gem 'mongoid', '>= 3.1.0'
    else
      gem 'mongoid', '>= 3.0.0'
    end
  when 'mongo'
    gem 'mongo'
  else
    gem 'mongo' # So rake test_all can wait for Mongo to start
  end

  gem 'pry'

  if RUBY_PLATFORM == 'java'
    gem 'jdbc-sqlite3'
    gem 'activerecord-jdbc-adapter'
    gem 'activerecord-jdbcsqlite3-adapter'
    gem 'jruby-openssl'
    gem 'jruby-rack'
  else
    gem 'sqlite3' # for devise User storage
  end

  if RAILS_VERS
    gem 'rails', RAILS_VERS
  else
    gem 'rails'
  end
  gem 'test-unit'

  gem 'rspec-rails', '2.12.0'
  gem 'devise'
end
