class CreateAnswersIndex < ActiveRecord::Migration
  def self.up
    add_index :answers, :question_id
    add_index :answers, :code_id
    add_index :answers, :project_id
    add_index :answers, :group_id
  end

  def self.down
    remove_index :answers, :question_id
    remove_index :answers, :code_id
    remove_index :answers, :project_id
    remove_index :answers, :group_id
  end
end
