# == Schema Information
# Schema version: 20090828145656
#
# Table name: question_items
#
#  id          :integer(4)      not null, primary key
#  question_id :integer(4)
#  choice_id   :integer(4)
#  description :text
#  position    :integer(4)
#  user_id     :integer(4)
#  active      :boolean(1)      default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

class QuestionItem < ActiveRecord::Base
  acts_as_list :scope => :question_id
  belongs_to :question
  belongs_to :choice

  def parent_object
    return question
  end

  def child_object
    return choice
  end

end
