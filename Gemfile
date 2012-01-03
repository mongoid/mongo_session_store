source :rubygems

MONGO_VERS = '1.4.0' unless defined? MONGO_VERS

RAILS_VERS = case ENV['RAILS_VERS']
             when '3.0'
               '~>3.0.0'
             when '3.1'
               '~>3.1.0'
             when '3.2'
               '3.2.0.rc1'
             when nil
               nil
             else
               raise "Invalid RAILS_VERS.  Available versions are 3.0, 3.1, and 3.2."
             end

gemspec

group :development, :test do
  gem 'rake'
  gem 'mongo_mapper', '>= 0.9.0'
  gem 'mongoid',      '>= 2.0'
  gem 'mongo',         MONGO_VERS
  gem 'bson_ext',      MONGO_VERS
  
  gem 'system_timer', :platforms => :ruby_18
  gem 'ruby-debug',   :platforms => :ruby_18
  gem 'ruby-debug19', :platforms => :ruby_19

  RAILS_VERS ? gem('rails', RAILS_VERS) : gem('rails')
  gem 'rspec-rails'
  gem 'devise'
end