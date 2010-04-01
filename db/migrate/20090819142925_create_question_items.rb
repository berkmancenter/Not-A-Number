class CreateQuestionItems < ActiveRecord::Migration
  def self.up
    create_table :question_items do |t|
      t.integer :question_id
      t.integer :choice_id
      t.text    :description
      t.integer :position
      t.integer :user_id
      t.boolean :active, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :question_items
  end
end
