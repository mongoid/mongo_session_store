ENV["RAILS_ENV"] = "test"
require "spec_helper"
require "rails"
rails_version = Gem.loaded_specs["rails"].version.to_s[/^\d\.\d/]
require "support/apps/rails_#{rails_version}_app/config/environment"
require "rspec/rails"

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.before :suite do
    Rails.logger.level = 4
    unless User.table_exists?
      load Rails.root.join("db", "schema.rb")
    end
  end

  config.before :each do
    drop_collections_in(test_database)
    User.delete_all
  end
end

puts "Testing #{mongo_orm}_store on Rails #{Rails.version}..."

case mongo_orm
when "mongoid"
  puts "Mongoid version: #{Mongoid::VERSION}"
when "mongo"
  puts "Mongo version: #{Mongo::VERSION}"
end
