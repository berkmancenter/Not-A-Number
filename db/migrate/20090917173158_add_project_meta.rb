class AddProjectMeta < ActiveRecord::Migration
  def self.up
    add_column :projects, :meta, :text
  end

  def self.down
    remove_column :projects, :meta
  end
end
