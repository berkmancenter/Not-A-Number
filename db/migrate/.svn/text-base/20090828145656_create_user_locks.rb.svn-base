class CreateUserLocks < ActiveRecord::Migration
  def self.up
    create_table :user_locks do |t|
      
      t.integer :user_id
      t.string  :user_anonymous_string
      t.integer :project_id
      t.integer :group_id
      t.boolean :completed, :default => false
      t.text    :user_meta
      t.string  :type
      t.timestamps
    end
  end

  def self.down
    drop_table :user_locks
  end
end
