class CreateChoices < ActiveRecord::Migration
  def self.up
    create_table :choices do |t|
      t.string  :title, :null => false
      t.string  :output_text,   :limit => 1024
      t.text    :description
      t.integer :user_id
      t.boolean :active, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :choices
  end
end
