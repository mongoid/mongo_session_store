require "rails_helper"

describe "Rack app", :type => :request do
  it "works with a mounted Rack app using Rack::Session" do
    if Gem.loaded_specs["rack"].version < Gem::Version.new("2.0.0")
      # Fails on trying to stringify the Rack::Session::Id object. Unrelated to
      # this gem's code.
      #
      #   NoMethodError:
      #   undefined method `each' for #<ActionDispatch::Request::Session:...>
      #
      # Skip spec setup for older Rack versions.
      skip "Incompatible Rack version"
    end

    get "/rack_test"
    expect(response.body.squish).to eql("Hello Rack app!")
  end
end
