module TestDatabaseHelper
  module_function

  def test_database
    case mongo_orm
    when "mongoid"
      MongoidStore::Session.mongo_client
    when "mongo"
      MongoStore::Session.database.database
    end
  end

  def drop_collections_in(database)
    database.collections.select { |c| c.name !~ /^system/ }.each(&:drop)
  end

  def test_database_name
    "test_database"
  end
end
