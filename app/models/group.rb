# == Schema Information
# Schema version: 20090828145656
#
# Table name: groups
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

class Group < ActiveRecord::Base
  acts_as_authorization_object
  has_one :project_item, :dependent => :destroy
  has_one :project, :through => :project_item

  has_many :group_items, :order => :position
  has_many :questions, :through => :group_items, :order => "group_items.position"

  def current_user
    session = UserSession.find
    current_user = session && session.user
    return current_user
  end  

  def self.connection_model
    return GroupItem
  end

  def connection_objects
    return group_items
  end

  def child_model
    return Question
  end

  def child_collection
    return questions
  end

  def self.available_items(project)
    items = ProjectItem.find(:all, :conditions => {:project_id => project.id})

    if items.blank?
      return Group.all
    else
      id_array = items.collect(&:group_id)
      return Group.find(:all, :conditions => ["id NOT IN (?)",  id_array])
    end    
  end


end
