class CreateIndexes < ActiveRecord::Migration
  def self.up
    add_index :branches, :project_id
    add_index :branches, :question_id
    add_index :branches, :group_id
    add_index :branches, :choice_id
    add_index :branches, :destination_group_id
    add_index :branches, :return_group_id
    add_index :choices, :id, :unique => true
    add_index :choices, :title
    add_index :choices, :output_text
    add_index :choices, :active
    add_index :group_items, :group_id
    add_index :group_items, :question_id
    add_index :project_items, :project_id
    add_index :project_items, :group_id
    add_index :question_items, :question_id
    add_index :question_items, :choice_id
    add_index :target_list_items, :target_list_id
    add_index :target_list_items, :target_id
  end

  def self.down
    remove_index :branches, :project_id
    remove_index :branches, :question_id
    remove_index :branches, :group_id
    remove_index :branches, :choice_id
    remove_index :branches, :destination_group_id
    remove_index :branches, :return_group_id
    remove_index :choices, :id
    remove_index :choices, :title
    remove_index :choices, :output_text
    remove_index :choices, :active
    remove_index :group_items, :group_id
    remove_index :group_items, :question_id
    remove_index :project_items, :project_id
    remove_index :project_items, :group_id
    remove_index :question_items, :question_id
    remove_index :question_items, :choice_id
    remove_index :target_list_items, :target_list_id
    remove_index :target_list_items, :target_id
  end
end
