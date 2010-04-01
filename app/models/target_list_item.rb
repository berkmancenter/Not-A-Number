class TargetListItem < ActiveRecord::Base
  acts_as_list :scope => :target_list_id
  belongs_to :target_list
  belongs_to :target

  def parent_object
    return target_list
  end

  def child_object
    return target
  end
end
