require 'securerandom'

$:.unshift File.dirname(__FILE__)

require 'mongo_session_store/mongo_mapper'
require 'mongo_session_store/mongoid'
require 'mongo_session_store/mongo'