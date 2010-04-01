class CreateProjectItems < ActiveRecord::Migration
  def self.up
    create_table :project_items do |t|
      t.integer :project_id
      t.integer :group_id
      t.text    :description
      t.integer :position
      t.string :type
      t.integer :user_id
      t.boolean :active, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :project_items
  end
end
