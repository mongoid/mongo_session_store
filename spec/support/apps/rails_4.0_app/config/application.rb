require File.expand_path("../boot", __FILE__)

require "action_controller/railtie"
require "active_record/railtie"

Bundler.require(:default, Rails.env)

module Rails40App
  class Application < Rails::Application
  end
end
