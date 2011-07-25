# Be sure to restart your server when you modify this file.

# Rails30App::Application.config.session_store :cookie_store, :key => '_rails_3.0_app_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
Rails30App::Application.config.session_store :"#{ENV['MONGO_SESSION_STORE_ORM']}_store"
