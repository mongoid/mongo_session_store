if mongo_orm == "mongo"
  MongoStore::Session.database = Mongo::Client.new(["127.0.0.1:27017"], database: "rails40_app_#{Rails.env}")
end
Rails40App::Application.config.session_store :"#{mongo_orm}_store"
