# == Schema Information
# Schema version: 20090828145656
#
# Table name: user_locks
#
#  id                    :integer(4)      not null, primary key
#  user_id               :integer(4)
#  user_anonymous_string :string(255)
#  project_id            :integer(4)
#  group_id              :integer(4)
#  completed             :boolean(1)
#  user_meta             :text
#  type                  :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

class UserLock < ActiveRecord::Base

  belongs_to :project
  has_one :user
  has_one :group

  def self.current_user
    session = UserSession.find
    current_user = session && session.user
    return current_user
  end

  # Will return the lock for the current project/group or create a new one
  def self.lock(project, group, code, session_id, user_meta = nil)

      lock_hash = {
        :project_id => project.id,
        :group_id => group.id,
        :code_id => code.id
      }

      if self.current_user.nil?
        lock_hash[:session_id] = session_id
        lock_hash[:user_id] = nil
      else
        lock_hash[:user_id] = self.current_user.id
      end

      user_lock = self.find(:first, :conditions => lock_hash)

      if user_lock.blank? then
        lock_hash[:session_id] = session_id
        lock_hash[:user_meta] = user_meta
        user_lock = UserLock.create(lock_hash)
      end
    
      return user_lock
  end


### This section may no longer be needed
#  def get_lock(project, group)
#    lock_hash = {
#      :project_id => project.id,
#      :group_id => group.id,
#      :code_id => code.id
#    }
#
#    return self.find(:all, :conditions => {:user_id => self.current_user.id,
#      :project_id => project.id,
#      :group_id => group.id
#      })
#  end
#
#  def get_locks
#    return self.find(:all, :conditions => {:user_id => self.current_user.id})
#  end

  def complete
    return self.update_attribute :completed, true
  end



end
