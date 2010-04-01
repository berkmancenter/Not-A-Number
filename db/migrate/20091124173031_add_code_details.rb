class AddCodeDetails < ActiveRecord::Migration
  def self.up
    add_column :codes, :completed, :boolean, :default => false
    add_column :codes, :meta, :text
  end

  def self.down
    remove_column :codes, :meta
    remove_column :codes, :completed
  end
end


