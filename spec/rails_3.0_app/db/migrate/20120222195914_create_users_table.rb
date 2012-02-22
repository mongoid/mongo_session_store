class CreateUsersTable < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.database_authenticatable :null => false
      # t.recoverable
      # t.rememberable
      # t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable
    end
  end

  def self.down
    drop_table :users
  end
end
