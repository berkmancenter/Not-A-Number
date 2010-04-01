# == Schema Information
# Schema version: 20090828145656
#
# Table name: choices
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)     not null
#  output_text :string(1024)
#  description :text
#  user_id     :integer(4)
#  active      :boolean(1)      default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

class Choice < ActiveRecord::Base
  acts_as_authorization_object
  has_one :question_item, :dependent => :destroy
  has_one :question, :through => :question_items

  validates_presence_of :title

  def self.available_items(question)
    items = QuestionItem.find(:all, :conditions => {:question_id => question.id})

    if items.blank?
      return Choice.all
    else
      id_array = items.collect(&:choice_id)
      return Choice.find(:all, :conditions =>  ["id NOT IN (?)", id_array])
    end
  end

end
