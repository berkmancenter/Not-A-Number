# == Schema Information
# Schema version: 20090828145656
#
# Table name: questions
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)     not null
#  output_text :string(1024)
#  description :text
#  type        :string(255)
#  user_id     :integer(4)
#  active      :boolean(1)      default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

class Question < ActiveRecord::Base

  include NanUtilities
  
  acts_as_authorization_object
  has_one :group_item, :dependent => :destroy
  has_one :group, :through => :group_item

  has_many :question_items, :order => :position
  has_many :choices, :through => :question_items, :order => "question_items.position"
  has_many :branches

  def current_user
    session = UserSession.find
    current_user = session && session.user
    return current_user
  end
  
  def number?
    if self.class == QuestionNote || self.class == QuestionTarget
      return false
    else  
      return true
    end
  end

  def render(code, nancode, session_id = nil, question_iterator = nil)
    recent_answer = recent_answer(code, nancode)
    question_content = <<-QUESTION_CONTENT
      <div class="question-container">
        #{question_render(nancode, session_id, question_iterator)}<br />
        #{choice_render(code, nancode, session_id)}<br />
      </div>
    QUESTION_CONTENT

    return question_content
  end

  def recent_answer(code, nancode)

    nancode_array = nancode.split("-")
    project_id = nancode_array[1].to_i
    group_id = nancode_array[2].to_i

    #code.user_id.nil? ? user_id = nil : user_id = code.user_id

    answer = Answer.find(:first, :conditions => {:project_id => project_id,
        :group_id => group_id,
        :question_id => self.id,
        :code_id => code.id,
      })

    return answer
  end

  def recent_answer_value(code, nancode)
    return self.recent_answer(code, nancode).blank? ? "" : self.recent_answer(code, nancode).answer_data
  end

  def report_data(code, nancode)
    return self.recent_answer(code, nancode).blank? ? "" : "\"#{CGI.escapeHTML(self.recent_answer(code, nancode).answer_data)}\""
  end

  # Renders entire question

  # Renders the opening text of the question
  def question_render(nancode, session_id = nil, question_iterator = nil)

    nancode = "#{nancode}-Q"
    question_iterator.blank? ? qnumber = '' : qnumber = "#{question_iterator}. "
    question_content = <<-QUESTION_CONTENT
      <div id="#{nancode}" name="#{nancode}" class="question question-#{self.type.to_s.downcase}">
        #{qnumber} #{self.output_text}
      </div>
    QUESTION_CONTENT

    return question_content

  end

  # Renders the choices available if any
  def choice_render(code, nancode, session_id = nil, answer = nil)
    return ""
  end

  def self.available_items(group)
    items = GroupItem.find(:all, :conditions => {:group_id => group.id, :active => true})

    if items.blank?
      return Question.all
    else
      id_array = items.collect(&:question_id)
      return Question.find(:all, :conditions =>  ["id NOT IN (?)", id_array])
    end  
  end

  def self.connection_model
    return QuestionItem
  end

  def connection_objects
    return question_items
  end

  def child_model
    return Choice
  end

  def child_collection
    return choices
  end

  def nancode_array(nancode)
    array = nancode.split("-")

    return array
  end

  def nancode_project(nancode)
    return Project.find(nancode_array(nancode)[1].to_i)
  end

  def nancode_group(nancode)
    return Project.find(nancode_array(nancode)[2].to_i)
  end

  def nancode_item(nancode)
    array = nancode_array(nancode)
    return GroupItem.find(:first, :conditions => {:group_id => array[2].to_i, :question_id => self.id})
  end
    
end

class QuestionText < Question
  
  def choice_render(code, nancode, session_id = nil, answer = nil)

    nancode = "#{nancode}-#{self.id}-#{self.group_item.position}"

    nancode_item(nancode).required ? validation_class = "required" : validation_class = ""

    #test_value = "#{self.group.project.id}:#{self.group.id}:#{self.id}:#{self.current_user.id}"

    choice_content = <<-CHOICE_CONTENT
      <input type='text' id='#{nancode}' NAME='#{nancode}' value='#{self.recent_answer_value(code, nancode)}' size='' maxlength='' class='choice choice-#{self.type.downcase} #{validation_class}' />
    CHOICE_CONTENT

    return choice_content
  end

end

class QuestionTextArea < Question

  def choice_render(code, nancode, session_id = nil)
    
    nancode = "#{nancode}-#{self.id}-#{self.group_item.position}"

    nancode_item(nancode).required ? validation_class = "required" : validation_class = ""

    choice_content = <<-CHOICE_CONTENT
      <textarea id='#{nancode}' name='#{nancode}' cols='75' rows='5' class='choice choice-#{self.type.downcase} #{validation_class}'>#{self.recent_answer_value(code, nancode)}</textarea>
    CHOICE_CONTENT

    return choice_content
  end

end

class QuestionRadio < Question

  def recent_answer_value(code, nancode)
    #return self.recent_answer.choice_id.blank? ? 0 : self.recent_answer.choice_id
    return self.recent_answer(code, nancode).blank? ? 0 : self.recent_answer(code, nancode).choice_id
  end

  def choice_render(code, nancode, session_id = nil)

    nancode = "#{nancode}-#{self.id}-#{self.group_item.position}"

    nancode_item(nancode).required ? validation_class = "validate-one-required" : validation_class = ""

    choices = self.choices

    choice_content = ""

    choice_id = recent_answer_value(code, nancode)

    choice_content += "<div class='radio'>"

    choices.each do |choice|

      #overrides validation class to put class online on the final item
      choice == choices.last ? choice_validation_class = validation_class : choice_validation_class = ""

      nancode_choice = "#{nancode}[#{choice.id}]"

      choice_id == choice.id ? choice_text = "checked='checked'" : choice_text = ""

      choice_content += <<-CHOICE_CONTENT
        <INPUT TYPE='radio' id='#{nancode}' name='#{nancode}' value='#{choice.id}' #{choice_text} class='choice choice-#{self.type.downcase} #{choice_validation_class}'/>
        #{choice.output_text}<br />
      CHOICE_CONTENT
    end

    choice_content += "</div>"

    return choice_content
  end

  def report_data(code, nancode)
    return self.recent_answer(code, nancode).blank? ? "" : "\"#{CGI.escapeHTML(self.recent_answer(code, nancode).choice.output_text)}\""
  end
  
end

class QuestionCheckbox < Question

  def recent_answer_value(code, nancode)
    return self.recent_answer(code, nancode).blank? ? Hash.new : ActiveSupport::JSON.decode(self.recent_answer(code, nancode).answer_data)
  end

  def choice_render(code, nancode, session_id = nil)

    nancode = "#{nancode}-#{self.id}-#{self.group_item.position}"

    nancode_item(nancode).required ? validation_class = "validate-one-required" : validation_class = ""

    choices = self.choices

    choice_content = ""

    choices.each do |choice|

      #overrides validation class to put class online on the final item
      choice == choices.last ? choice_validation_class = validation_class : choice_validation_class = ""

      nancode_choice = "#{nancode}[#{choice.id}]"

      self.recent_answer_value(code, nancode).has_key?(choice.id.to_s) ? choice_text = "checked='checked'" : choice_text = ""

      choice_content += <<-CHOICE_CONTENT
        <INPUT TYPE='checkbox' id='#{nancode}' name='#{nancode_choice}' value='#{choice.output_text}' #{choice_text} class='choice choice-#{self.type.downcase} #{choice_validation_class}'/>
        #{choice.output_text}<br />
      CHOICE_CONTENT
    end

    return choice_content
  end

  def report_data(code, nancode)
    return self.recent_answer(code, nancode).blank? ? "" : "\"#{CGI.escapeHTML(self.recent_answer(code, nancode).answer_data.gsub('"',"'"))}\""
  end


end

class QuestionDropDown < Question

  def recent_answer_value(code, nancode)
    return self.recent_answer(code, nancode).blank? ? 0 : self.recent_answer(code, nancode).choice_id
  end

  def choice_render(code, nancode, session_id = nil)

    nancode = "#{nancode}-#{self.id}-#{self.group_item.position}"

    nancode_item(nancode).required ? validation_class = "validate-selection" : validation_class = ""

    choices = self.choices

    choice_id = recent_answer_value(code, nancode)

    choice_content = <<-CHOICE_CONTENT
    <select class='validate-selection' id='#{nancode}' name='#{nancode}' class='choice choice-#{self.type.downcase} #{validation_class}'>
    <option value=''>--</option>
    CHOICE_CONTENT
    
    choices.each do |choice|

      nancode_choice = "#{nancode}[#{choice.id}]"

      choice_id == choice.id ? choice_text = "selected='selected'" : choice_text = ""

      choice_content += <<-CHOICE_CONTENT
        <option value='#{choice.id}' #{choice_text} >#{choice.output_text}</option>
      CHOICE_CONTENT
    end

    choice_content += <<-CHOICE_CONTENT
      </select>
    CHOICE_CONTENT

    return choice_content
  end
  
end

class QuestionNote < Question
end

class QuestionTarget < Question

  # This will pull the target id that has been selected

  def recent_answer_value(code, nancode)
    return self.recent_answer(code, nancode).blank? ? nil : self.recent_answer(code, nancode).answer_data.to_i
  end

  def report_data(code, nancode)
    if !self.recent_answer(code, nancode).blank?
      target = Target.find(self.recent_answer(code, nancode).answer_data.to_i)
    end
    
    return self.recent_answer(code, nancode).blank? ? "" : "\"#{CGI.escapeHTML(target.content)}\""
  end

  # Renders the previously selected target or grabs the next target in list
  # dependant on the behavior selected when the question was created
  #--
  # FIXME: Additional behaviors need to be added
  # FIXME: Currently subtracting arrays, may need to convert to a "NOT IN" sql statement
  #++

  def choice_render(code, nancode, session_id = nil)

    target_content = "N/A: Please see your administrator"
    target_name = "N/A: Please see your administrator"
    
    if self.recent_answer_value(code, nancode).nil?
      target = Target.find(self.remaining_target_ids(nancode, session_id).first) unless self.remaining_target_ids(nancode, session_id).blank?
    else
      target = Target.find(self.recent_answer_value(code, nancode).to_i)
    end

    if target
      target_content = target.content
      target_name = target.display_name
      target_description = target.description

      nancode = "#{nancode}-#{self.id}-#{self.group_item.position}"
      save_answer(code, nancode, target.id, session_id)
    end

    choice_content = <<-CHOICE_CONTENT
      <a href="#{target_content}" target="_blank">#{target_name}</a><br />
      <div id="description">#{target_description}</div>
    CHOICE_CONTENT

    return choice_content
  end

  def behavior
    meta_hash = ActiveSupport::JSON.decode(self.meta)

    return meta_hash["behavior"]
  end

  def target_list_id
    meta_hash = ActiveSupport::JSON.decode(self.meta)

    return meta_hash["target_list_id"].to_i
  end

  def remaining_target_ids(nancode, session_id)
    
      nancode_array = nancode.split("-")
      project_id = nancode_array[1].to_i
      group_id = nancode_array[2].to_i
      result_array = Array.new
      answer_hash = Hash.new

      answer_hash = {
        :project_id => project_id,
        :group_id => group_id,
        :question_id => self.id
      }

      if self.behavior == "Sequential"
        if current_user.nil?
          answer_hash[:user_id] = nil
          answer_hash[:session_id] = session_id
        else
          answer_hash[:user_id] = current_user.id
        end
        used_targets = Answer.find(:all, :conditions => answer_hash)
        targets_list_items = TargetListItem.find(:all, :conditions => {:target_list_id => self.target_list_id})

        used_targets.length == 0 ? used_target_array = Array.new : used_target_array = used_targets.collect{|answer| answer.answer_data.to_i}
        targets_list_items_array = targets_list_items.collect(&:target_id)
        result_array = targets_list_items_array.uniq - used_target_array.uniq
      
      elsif self.behavior == "Sequential Distinct"
        used_targets = Answer.find(:all, :conditions => answer_hash)
        targets_list_items = TargetListItem.find(:all, :conditions => {:target_list_id => self.target_list_id})

        used_targets.length == 0 ? used_target_array = Array.new : used_target_array = used_targets.collect{|answer| answer.answer_data.to_i}
        targets_list_items_array = targets_list_items.collect(&:target_id)
        result_array = targets_list_items_array.uniq - used_target_array.uniq  
      end

     return result_array
  end

end

class QuestionAutocompleteChoice < Question

   def choice_render(code, nancode, session_id = nil, answer = nil)

    nancode = "#{nancode}-#{self.id}-#{self.group_item.position}"

    nancode_item(nancode).required ? validation_class = "required" : validation_class = ""

    choice_content = <<-CHOICE_CONTENT
      <input type="text" id='#{nancode}' name='#{nancode}' value='#{self.recent_answer_value(code, nancode)}' size='' maxlength='' class='choice choice-#{self.type.downcase} #{validation_class}'/>
        <span id="indicator_#{nancode}" style="display: none">
          <img src="/images/spinner.gif" alt="Working..." />
        </span>
      <div id="#{nancode}_autocomplete_choices" class="autocomplete"></div>

      <script type="text/javascript">
        new Ajax.Autocompleter("#{nancode}", "#{nancode}_autocomplete_choices", '/projects/autocomplete_choices?question_id=#{self.id}', {
          paramName: "value",
          minChars: 2,
          indicator: 'indicator_#{nancode}'
        });
      </script>

    CHOICE_CONTENT

    return choice_content
  end

end