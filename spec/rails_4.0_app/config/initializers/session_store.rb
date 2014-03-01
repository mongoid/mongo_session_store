# Be sure to restart your server when you modify this file.

# Rails40App::Application.config.session_store :cookie_store, key: '_rails_4_0_app_session'
MongoStore::Session.database = Mongo::Connection.new.db("rails40_app_#{Rails.env}") if ENV['MONGO_SESSION_STORE_ORM'] == "mongo"
Rails40App::Application.config.session_store :"#{ENV['MONGO_SESSION_STORE_ORM']}_store"
