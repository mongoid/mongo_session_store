require File.expand_path("../lib/mongo_session_store/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "mongo_session_store"
  s.version = MongoSessionStore::VERSION

  s.authors          = ["Tom de Bruijn", "Brian Hempel", "Nicolas M\303\251rouze", "Tony Pitale", "Chris Brickley"]
  s.email            = ["plasticchicken@gmail.com"]
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,perf}/*`.split("\n")
  s.homepage         = "http://github.com/appsignal/mongo_session_store"
  s.license          = "MIT"
  s.require_paths    = ["lib"]
  s.rubygems_version = "1.3.7"
  s.summary          = "Rails session stores for Mongoid, or any other ODM. Rails 4.0+ compatible."

  s.add_dependency "actionpack", ">= 4.0"
  s.add_dependency "mongo", ">= 1.0"
  s.add_development_dependency "rspec-rails", "3.5.2"
  s.add_development_dependency "pry"
  s.add_development_dependency "rake"
  s.add_development_dependency "rubocop", "0.45.0"
end
