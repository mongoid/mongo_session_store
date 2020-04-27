ENV["RAILS_ENV"] = "test"
rails_version = Gem.loaded_specs["rails"].version.to_s[/^\d\.\d/]
if Gem.loaded_specs["rails"].version >= Gem::Version.new("5.2")
  require "active_support/message_encryptor"
end
require "spec_helper"
require "rails"
require "support/rack_app"
require "support/apps/rails_#{rails_version}_app/config/environment"
require "rspec/rails"

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.before :suite do
    Rails.logger.level = 4
    load Rails.root.join("db", "schema.rb") unless User.table_exists?
  end

  config.before :each do
    User.delete_all
  end
end
