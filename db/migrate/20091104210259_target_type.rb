class TargetType < ActiveRecord::Migration
  def self.up
    create_table :target_types do |t|
      t.string  :title, :null => false
      t.string  :output_text,   :limit => 1024
      t.text    :description
      t.integer :user_id
      t.boolean :active, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :target_types
  end
end
