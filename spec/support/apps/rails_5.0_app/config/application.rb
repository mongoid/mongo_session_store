require_relative "boot"

require "action_controller/railtie"
require "active_record/railtie"

Bundler.require(*Rails.groups)

module Rails50App
  class Application < Rails::Application
  end
end
