class CreateProjectStyles < ActiveRecord::Migration
  def self.up
    create_table :project_styles do |t|

      t.integer :project_id
      t.string  :title

      t.timestamps
    end
  end

  def self.down
    drop_table :project_styles
  end
end
