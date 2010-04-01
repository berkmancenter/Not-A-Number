class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|

      t.integer :project_id
      t.integer :group_id
      t.integer :question_id
      t.integer :choice_id
      t.integer :user_id
      t.integer :saved_position
      t.text    :answer_data

      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end
