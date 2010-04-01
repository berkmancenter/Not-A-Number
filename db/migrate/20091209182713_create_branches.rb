class CreateBranches < ActiveRecord::Migration
  def self.up
    create_table :branches do |t|
      t.integer :project_id
      t.integer :question_id
      t.integer :group_id
      t.integer :choice_id
      t.integer :destination_group_id
      t.integer :return_group_id
      t.timestamps
    end
  end

  def self.down
    drop_table :branches
  end
end
