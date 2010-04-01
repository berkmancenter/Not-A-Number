class CreateTargetListItems < ActiveRecord::Migration
  def self.up
    create_table :target_list_items do |t|
      t.integer :target_list_id
      t.integer :target_id
      t.text    :description
      t.text    :notes
      t.integer :position
      t.integer :user_id
      t.boolean :active, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :target_list_items
  end
end
