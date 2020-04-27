require_relative 'boot'

require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rails60App
  class Application < Rails::Application
    config.load_defaults 6.0
    config.generators.system_tests = nil
  end
end
