class TargetList < ActiveRecord::Base
  acts_as_authorization_object
  has_many :target_list_items, :order => :position
  has_many :targets, :through => :target_list_items, :order => "target_list_items.position"

  def remaining(current_user)
    
  end

  def self.connection_model
    return TargetListItem
  end

  def connection_objects
    return target_list_items
  end

  def child_model
    return Target
  end

  def child_collection
    return targets
  end

end
