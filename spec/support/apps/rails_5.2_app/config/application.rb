require_relative "boot"

require "action_controller/railtie"
require "active_record/railtie"

Bundler.require(*Rails.groups)

module Rails52App
  class Application < Rails::Application
    config.load_defaults 5.2
  end
end
