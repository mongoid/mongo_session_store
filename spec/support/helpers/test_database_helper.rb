module TestDatabaseHelper
  def test_database
    case mongo_orm
    when "mongoid"
      MongoidStore::Session.mongo_client
    when "mongo"
      Mongo::Client.new(["127.0.0.1:27017"], database: test_database_name).database
    end
  end

  def drop_collections_in(database)
    database.collections.select { |c| c.name !~ /^system/ }.each(&:drop)
  end

  private

  def test_database_name
    Rails.application.class.to_s.underscore.sub(/\/.*/, "") + "_" + Rails.env
  end
end
