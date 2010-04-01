class Target < ActiveRecord::Base
  acts_as_authorization_object
  has_one :target_list_item, :dependent => :destroy
  has_one :target_list, :through => :target_list_item
  
  def self.available_items(target_list)
    items = TargetListItem.find(:all, :conditions => {:target_list_id => target_list.id})

    if items.blank?
      return Target.all
    else
      id_array = items.collect(&:target_id)
      return Target.find(:all, :conditions => ["id NOT IN (?)",  id_array])
    end
  end

  def display_name
    return self.output_text.blank? ? self.title : self.output_text
  end
  
end

class TargetUrl < Target
end
