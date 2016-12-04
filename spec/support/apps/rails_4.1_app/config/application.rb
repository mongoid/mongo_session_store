require File.expand_path("../boot", __FILE__)

require "action_controller/railtie"
require "active_record/railtie"

Bundler.require(*Rails.groups)

module Rails41App
  class Application < Rails::Application
  end
end
