class AddLockAnswerCodes < ActiveRecord::Migration
  def self.up
    add_column :answers, :code_id, :integer
    add_column :user_locks, :code_id, :integer
  end

  def self.down
    remove_column :answers, :code_id
    remove_column :user_locks, :code_id
  end
end
