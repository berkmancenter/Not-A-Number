# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include NanUtilities

  rescue_from Acl9::AccessDenied, :with => :deny_access

  helper :all
  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation

  before_filter :require_user
  
  layout :layout_switch

  # Switches to minimal layout for ModalBox calls
  def layout_switch
    if self.controller_name != "reports" && self.controller_name != "user_sessions" && self.action_name != "display"
      ["new", "edit", "branch"].include?(self.action_name) ? :minimal : :application
    elsif self.controller_name == "reports" && self.action_name == "display"
      nil
    elsif self.controller_name == "projects" && self.action_name == "display"
      :no_left_nav
    else
      :application
    end
  end

  # Method executed when Acl9::AccessDenied is caught
  # should redirect to page with appropriate info
  # and possibly raise a 403?
  #--
  # FIXME: Place in redirect to error page
  #++
  def deny_access
    
  end

  # Toggles the active switch on an object during an ajax call
  def toggle_active
    object_item = params[:controller].classify.constantize.connection_model.find(params[:object_item])
    object_item.toggle!(:active)

    render :update do |page|
      page.replace "item-#{params[:object_item]}-content", :partial => "projects/active_object_display", :locals => {:object_item => object_item, :object => object_item.parent_object}
    end
  end
  
  def toggle_require
    object_item = params[:controller].classify.constantize.connection_model.find(params[:object_item])
    object_item.toggle!(:required)

    render :update do |page|
      page.replace "item-#{params[:object_item]}-content", :partial => "projects/active_object_display", :locals => {:object_item => object_item, :object => object_item.parent_object}
    end
  end

  def add_item
    object = params[:controller].classify.constantize.find(params[:object])
    item_number = params[:item_number].to_i
    
    item_array = params[:id].split("-")

    child_object = object.child_model.find(item_array[1])

    object.child_collection << child_object

    object.connection_objects.last.insert_at(item_number)

    object_items = object.connection_objects
    available_items = object.child_model.available_items(object)

    render :update do |page|
      page.replace_html :object_item_list_container, :partial => "projects/object_item_list", :locals => {:object_items => object_items, :object => object }
      page.replace_html :object_list_container, :partial => "projects/inactive_list", :locals => {:available_objects => available_items, :object => object }
    end

  end

  def remove_item
    object_class = params[:controller].classify.constantize
    object = object_class.find(params[:object])

    item_array = params[:id].split("-")

    object_item = object_class.connection_model.find(item_array[1])

    object_item.destroy

    object_items = object.connection_objects
    available_items = object.child_model.available_items(object)

    render :update do |page|
      # page.alert params.inspect
      page.replace_html :object_item_list_container, :partial => "projects/object_item_list", :locals => {:object_items => object_items, :object => object }
      page.replace_html :object_list_container, :partial => "projects/inactive_list", :locals => {:available_objects => available_items, :object => object }
    end

  end

  def add_user
    object = params[:controller].classify.constantize.find(params[:object])
    item_number = params[:item_number].to_i
    
    item_array = params[:id].split("-")

    child_object = object.child_model.find(item_array[1])

    object.child_collection << child_object

    object.connection_objects.last.insert_at(item_number)

    object_items = object.connection_objects
    available_items = object.child_model.available_items(object)

    render :update do |page|
      page.replace_html :object_item_list_container, :partial => "projects/object_user_list", :locals => {:object_items => object_items, :object => object }
      page.replace_html :object_list_container, :partial => "projects/inactive_user_list", :locals => {:available_objects => available_items, :object => object }
    end
  end
  
  def remove_user
    object_class = params[:controller].classify.constantize
    object = object_class.find(params[:object])

    item_array = params[:id].split("-")

    object_item = object_class.connection_model.find(item_array[1])

    object_item.destroy

    object_items = object.connection_objects
    available_items = object.child_model.available_items(object)

    render :update do |page|
      # page.alert params.inspect
      page.replace_html :object_item_list_container, :partial => "projects/object_user_list", :locals => {:object_items => object_items, :object => object }
      page.replace_html :object_list_container, :partial => "projects/inactive_user_list", :locals => {:available_objects => available_items, :object => object }
    end

  end

  def sort_items
    object_class = params[:controller].classify.constantize

    items = params[:item_sort]
    item_update_hash = Hash.new

    items.each_with_index { |item, index|
      item_update_hash[item.to_i] = {:position => index}
    }

    object_class.connection_model.update(item_update_hash.keys, item_update_hash.values)

    render :update do |page|
      page['spinner_block'].hide()
    end
  end

    def save_answers(code, params)

      save_hash = Hash.new
      nancode_array = Array.new
      params.each_key do |key|
        nancode_array = key.split("-")
        if nancode_array[0] == "NANCODE"
          #save_answer(params[key])
          save_hash[key] = params[key] unless params[key].blank?
          save_answer(code, key, params[key], request.session_options[:id])
        end
      end

      return save_hash

    end

  # Called for autosave on the form by ajax
    def autosave_form
      code = Code.find(params[:code_id].to_i)
      save_answers(code, params)
    end

    # Called for autocomplete by ajax
    def autocomplete_choices
      question = Question.find(params[:question_id].to_i)
      autocomplete_value = params[:value]

      choices = QuestionItem.find_by_sql(["SELECT * FROM question_items LEFT JOIN choices ON question_items.choice_id = choices.id WHERE question_items.question_id = ? and choices.output_text like '%#{autocomplete_value}%' limit 10", question.id])

      content = "<ul>\n"
      choices.each do |choice|
        content += <<-AUTOCOMPLETE_CONTENT
        <li>#{choice.output_text}</li>
        AUTOCOMPLETE_CONTENT
      end
      content += "</ul>\n"
      
      render :inline => content
    end


  
  private



    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
    
    def require_user
      action_array = [
          "display",
          "completed",
      ]

      ajax_action_hash = [
          "autosave_form"
      ]

      if self.controller_name == "projects" && (action_array.include?(self.action_name))
        project = Project.find(params[:id])
        anonymous = project.anonymous?
      end

      unless current_user || anonymous || (ajax_action_hash.include?(self.action_name))
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

  def object_to_boolean(value)
    return [true, "true", 1, "1", "T", "t"].include?(value.class == String ? value.downcase : value)
  end
  
  def InitR
    @r = RSRuby.instance
    return @r
  end

end
