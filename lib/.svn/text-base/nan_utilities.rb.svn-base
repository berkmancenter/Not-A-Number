# To change this template, choose Tools | Templates
# and open the template in the editor.

module NanUtilities

  def save_answer(code, key, param, session_id)

    nancode_array = key.split("-")
    project_id = nancode_array[1].to_i
    group_id = nancode_array[2].to_i
    question_id = nancode_array[3].to_i
    position = nancode_array[4].to_i
    answer_data = ""
    choice_id = 0

    question = Question.find(question_id)

    answer_data = case question.class.to_s
    when "QuestionText"
      answer_data = param
    when "QuestionTextArea"
      answer_data = param
    when "QuestionRadio"
      choice_id = param.to_i
      answer_data = param
    when "QuestionCheckbox"
      answer_data = param.to_json
    when "QuestionNote"
      answer_data = param
    when "QuestionDropDown"
      choice_id = param.to_i
      answer_data = param
    else answer_data = param
    end
    
    data_hash = {
      :project_id => project_id,
      :group_id => group_id,
      :question_id => question_id,
      :code_id=> code.id
    }

    if !current_user.nil?
      data_hash[:user_id] = current_user.id
    end

    answer = Answer.find :first, :conditions => data_hash

    data_hash[:saved_position] = position
    data_hash[:answer_data] = answer_data
    data_hash[:choice_id] = answer_data
    data_hash[:session_id] = session_id

    if answer
      answer.update_attributes(data_hash)
    else
      Answer.create(data_hash)
    end

  end
  
end
