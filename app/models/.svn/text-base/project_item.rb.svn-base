# == Schema Information
# Schema version: 20090828145656
#
# Table name: project_items
#
#  id          :integer(4)      not null, primary key
#  project_id  :integer(4)
#  group_id    :integer(4)
#  description :text
#  position    :integer(4)
#  user_id     :integer(4)
#  active      :boolean(1)      default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

class ProjectItem < ActiveRecord::Base
  acts_as_list :scope => :project_id
  belongs_to :project
  belongs_to :group

  def parent_object
    return project
  end

  def child_object
    return group
  end

end
