# == Schema Information
# Schema version: 20090828145656
#
# Table name: group_items
#
#  id          :integer(4)      not null, primary key
#  group_id    :integer(4)
#  question_id :integer(4)
#  description :text
#  required    :boolean(1)
#  position    :integer(4)
#  user_id     :integer(4)
#  active      :boolean(1)      default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

class GroupItem < ActiveRecord::Base
  acts_as_list :scope => :group_id
  belongs_to :group
  belongs_to :question

  def parent_object
    return group
  end

  def child_object
    return question
  end

end
