ENV["MONGO_SESSION_STORE_ORM"] ||= "mongo_mapper"
ENV["RAILS_ENV"] = "test"

require 'bundler/setup'
$:.unshift File.dirname(__FILE__)
