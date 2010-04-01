class CreateGroupItems < ActiveRecord::Migration
  def self.up
    create_table :group_items do |t|
      t.integer :group_id
      t.integer :question_id
      t.text    :description
      t.boolean :required
      t.integer :position
      t.integer :user_id
      t.boolean :active, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :group_items
  end
end
