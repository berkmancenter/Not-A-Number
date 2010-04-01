# == Schema Information
# Schema version: 20090903160209
#
# Table name: answers
#
#  id             :integer(4)      not null, primary key
#  project_id     :integer(4)
#  group_id       :integer(4)
#  quesion_id     :integer(4)
#  choice_id      :integer(4)
#  user_id        :integer(4)
#  saved_position :integer(4)
#  answer_data    :text
#  created_at     :datetime
#  updated_at     :datetime
#

class Answer < ActiveRecord::Base
  belongs_to :code
  belongs_to :choice
end
