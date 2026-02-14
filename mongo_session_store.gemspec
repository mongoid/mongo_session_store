require File.expand_path("lib/mongo_session_store/version", __dir__)

Gem::Specification.new do |s|
  s.name = "mongo_session_store"
  s.version = MongoSessionStore::VERSION

  s.authors          = ["Tom de Bruijn", "Brian Hempel", "Nicolas M\303\251rouze", "Tony Pitale", "Chris Brickley"]
  s.email            = ["tom@tomdebruijn.com"]
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,perf}/*`.split("\n")
  s.homepage         = "http://github.com/mongoid/mongo_session_store"
  s.license          = "MIT"
  s.require_paths    = ["lib"]
  s.summary          = "Rails session stores for Mongoid, or any other ODM. Rails 4 compatible."
  s.required_ruby_version = ">= 1.9"

  s.add_dependency "actionpack", ">= 4.0"
  s.add_dependency "mongo", "~> 2.0"

  s.add_development_dependency "capybara", "~> 2.15.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec-rails", ">= 4.0"
end
