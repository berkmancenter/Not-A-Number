class AddAllowLogin < ActiveRecord::Migration
  def self.up
    add_column :users, :allow_login, :tinyint, :limit => 1, :default => 1, :null => false
  end

  def self.down
    remove_column :users, :allow_login
  end
end
