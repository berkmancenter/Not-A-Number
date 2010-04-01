class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.string  :title, :null => false
      t.string  :output_text,   :limit => 1024
      t.text    :description
      t.string :type
      t.integer :user_id
      t.boolean :active, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
