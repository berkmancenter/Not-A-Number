# == Schema Information
# Schema version: 20090828145656
#
# Table name: projects
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

class Project < ActiveRecord::Base
  acts_as_authorization_object
  has_many :project_items, :order => :position
  has_many :groups, :through => :project_items, :order => "project_items.position"
  has_many :user_locks
  has_many :codes
  has_one :project_style

  def current_user
    session = UserSession.find
    current_user = session && session.user
    return current_user
  end

  # Returns the current active group for the project.  If there are no locks then the first group in the list
  # will be returned
  def current_group(code)

    code.user_id.nil? ? current_user = nil : current_user = User.find(code.user_id)
    current_session_id = code.session_id

    # Testing to see if locks are associated with users otherwise we will use the session_id for anonymous folks.
    if !current_user.nil?
        user_symbol = :user_id
        user_id = current_user.id
    else
        user_symbol = :session_id
        user_id = current_session_id
    end

    user_lock = UserLock.find(:last, :conditions => {:project_id => self.id, user_symbol => user_id, :code_id => code.id ,:completed => false})
    completed_locks = UserLock.find(:all, :conditions => {:project_id => self.id, user_symbol => user_id, :code_id => code.id, :completed => true})

    completed_group_ids = completed_locks.collect(&:group_id)

    if user_lock.nil?
      if completed_group_ids.length > 0
        current_group = self.groups.first(:conditions => ["groups.id not in (?)", completed_group_ids])
      else
        current_group = self.groups.first
      end
    else
      current_group = Group.find(user_lock.group_id)
    end

    return current_group

  end

  def current_branch(save_hash)
    save_hash.each_key do |key|
        nancode_array = key.split("-")
        project_id = nancode_array[1].to_i
        group_id = nancode_array[2].to_i
        question_id = nancode_array[3].to_i
        choice_id = save_hash[key].to_i
        if choice_id > 0
           branch = Branch.find(:first, :conditions => {
               :project_id =>  project_id,
               :group_id => group_id,
               :question_id => question_id,
               :choice_id => choice_id
            })
        end
    end
  end

  def style
    project_style = ProjectStyle.find_by_project_id(self.id)

    if project_style.blank?
      return "project-default"
    else
      return project_style.title
    end
    
  end

  #Gets code if completed one exists, if not generates new one and returns
#  def code(session_id)
#
#    if current_user.nil?
#      code_record = Code.find(:last, :conditions => {:user_id => nil, :project_id => self.id, :completed => false, :session_id => session_id})
#    else
#      code_record = Code.find(:last, :conditions => {:user_id => current_user.id, :project_id => self.id, :completed => false})
#    end
#
#    if code_record.nil? then code_record = self.gen_code(current_user, session_id) end
#
#    return code_record
#  end

  #If a code exists for this user it will be returned
  def current_code(session_id)

    if !current_user.nil?
      code_record = Code.find(:last, :conditions => {:user_id => current_user.id, :project_id => self.id, :completed => false})
    else
      code_record = Code.find(:last, :conditions => {:user_id => nil, :project_id => self.id, :completed => false, :session_id => session_id})
    end

    return code_record
  end

  # Generates new code in Code table.  Initial state is :completed => false
  def gen_code(session_id)
      salt = Authlogic::Random.hex_token
      completion_code =  Digest::MD5.hexdigest("#{self.id}-#{Time.now}-" + salt)
      
      current_user.nil? ? user_id = nil : user_id = current_user.id

      code_record = Code.create(:user_id => user_id, :project_id => self.id, :code => completion_code, :session_id => session_id)

      return code_record
  end

  def completed_count(session_id)
    if current_user.nil?
     return Code.count(:conditions => {:project_id => self.id, :session_id => session_id, :completed => true})
    elsif !session_id.blank?
     return Code.count(:conditions => {:project_id => self.id, :user_id => current_user.id, :completed => true})
    else
     return 0
    end
  end

  def targets?
    target_questions_count = 0

    self.groups.each do |group|
      target_questions_count += group.questions.count(:conditions => {:type => "QuestionTarget"})
    end
    
    return target_questions_count > 0 ? true : false
  end

  def remaining_targets(session_id)

    total_targets = 0

    self.groups.each do |group|
      target_questions = group.questions.find(:all, :conditions => {:type => "QuestionTarget"})

      target_questions.each do |question|
        nancode = "NANCODE-#{self.id}-#{group.id}"
        target_id_array = question.remaining_target_ids(nancode, session_id)
        total_targets += target_id_array.length
      end
    end

    return total_targets
  end

  def anonymous?
    meta_hash = self.meta_hash
    return  object_to_boolean(meta_hash["allow_anonymous"])
  end

  def turk?
    meta_hash = self.meta_hash
    return  object_to_boolean(meta_hash["allow_turk"])
  end

  def interstitial?
    meta_hash = self.meta_hash
    return  object_to_boolean(meta_hash["allow_interstitial"])
  end

  def meta_hash
    return ActiveSupport::JSON.decode(self.meta)
  end

  def self.connection_model
    return ProjectItem
  end

  def connection_objects
    return project_items
  end

  def child_model
    return Group
  end

  def child_collection
    return groups
  end

  def object_to_boolean(value)
    return [true, "true", 1, "1", "T", "t"].include?(value.class == String ? value.downcase : value)
  end
end
