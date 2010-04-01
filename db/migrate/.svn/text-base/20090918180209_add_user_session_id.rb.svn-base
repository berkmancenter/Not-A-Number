class AddUserSessionId < ActiveRecord::Migration
  def self.up
    add_column :user_locks, :session_id, :string
    add_column :answers, :session_id, :string
  end

  def self.down
    remove_column :user_locks, :session_id
    remove_column :answers, :session_id
  end
end
