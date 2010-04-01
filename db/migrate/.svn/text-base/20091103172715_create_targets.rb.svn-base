class CreateTargets < ActiveRecord::Migration
  def self.up
    create_table :targets do |t|
      t.string :title, :null => false
      t.string  :output_text,   :limit => 1024
      t.text  :description
      t.text  :notes
      t.text  :content
      t.integer :user_id
      t.string :type
      t.boolean :active, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :targets
  end
end
