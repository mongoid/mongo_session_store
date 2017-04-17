module SessionIdHelper
  def generate_sid
    ActionDispatch::Session::MongoStoreBase.new(nil).generate_sid
  end
end
