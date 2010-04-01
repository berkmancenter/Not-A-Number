class ProjectsController < ApplicationController

  access_control do
    allow anonymous, :to => [:index, :new, :create, :display, :completed, :autocomplete_choices, :autosave_form]
    allow logged_in, :to => [:index, :new, :create, :display, :completed, :autocomplete_choices, :autosave_form]
    allow :admin
    allow :owner, :of => :project
    allow :manager, :of => :project, :to => [:index, :show, :new, :edit, :create, :update, :display, :assignuser, :newuser, :createuser, :autocomplete_choices, :autosave_form]
    allow :editor, :of => :project, :to => [:index, :show, :edit, :update, :display, :autocomplete_choices, :autosave_form]
    allow :project_user, :of => :project, :to => [:index, :display, :autocomplete_choices, :autosave_form]
  end
 
  # GET /projects
  # GET /projects.xml
  def index
    #@projects = Project.all
    projectids = []
    allprojects = Role.find_by_sql(["select id, authorizable_id from roles join roles_users on roles.id = roles_users.role_id where roles.authorizable_type = 'Project' and roles_users.user_id = ?", current_user])
    projectids = allprojects.collect{|p| p.authorizable_id}
    @projects = Project.find(:all, :conditions => {:id => projectids})
    
    alltargetlists = Role.find_by_sql(["select id, authorizable_id from roles join roles_users on roles.id = roles_users.role_id where roles.authorizable_type = 'TargetList' and roles_users.user_id = ?", current_user])
    targetlistids = alltargetlists.collect{|t| t.authorizable_id}
    @target_lists = TargetList.find(:all, :conditions => {:id => targetlistids})
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])
    @project_items = @project.project_items

    @available_groups = Group.available_items(@project)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new
    @source = params[:source]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    @source = params[:source]

    meta_hash = ActiveSupport::JSON.decode(@project.meta)

    @allow_interstitial = object_to_boolean(meta_hash["allow_interstitial"])
    @allow_anonymous = object_to_boolean(meta_hash["allow_anonymous"])
    @allow_turk = object_to_boolean(meta_hash["allow_turk"])
  end

  # POST /projects
  # POST /projects.xml
  def create
    params[:project][:user_id] = current_user.id
    @project = Project.new(params[:project])
    @source = params[:source]


    allowed_hash = {:allow_anonymous => params[:allow_anonymous], :allow_turk => params[:allow_turk], :allow_interstitial => params[:allow_interstitial]}
    @project.meta = allowed_hash.to_json

    @project.accepts_role!(:owner, current_user)

    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to(:back) }
        format.xml  { head :ok }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])
    @source = params[:source]

    allowed_hash = {:allow_anonymous => params[:allow_anonymous], :allow_turk => params[:allow_turk], :allow_interstitial => params[:allow_interstitial]}
    params[:project][:meta] = allowed_hash.to_json
    
    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(:back) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @source = params[:source]

    @project.destroy

    respond_to do |format|

      if @source == "dialog_index"
        format.html { redirect_to(:back) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(projects_url) }
        format.xml  { head :ok }
      end

    end
  end

  # Method displays the user view of the project
  def display
    @project = Project.find(params[:id])
 
    # Grabbing any config info we need to make decisions
    meta_hash = ActiveSupport::JSON.decode(@project.meta)
    
    complete_flag = false
    next_flag = false
    interstitial_flag = object_to_boolean(meta_hash["allow_interstitial"])

    @code = @project.current_code(request.session_options[:id])

    # If the page was submitted save answers and complete locks
    unless params[:commit].blank?
      # Grab current code and save parameters if page was committed.
      @save_hash = save_answers(@code, params)
      @group = Group.find(params[:group])
      @branch = Branch.find(params[:branch]) unless params[:branch].blank?
      
      UserLock.lock(@project, @group, @code, request.session_options[:id]).complete

      @selected_branch = select_branch(params, @project.id, @group.id)

    end

    if @code.nil?
      # Behavior is different if the project includes targets
      if @project.targets?
        # Are there any targets left? If not we will complete the project
        if @project.remaining_targets(request.session_options[:id]) > 0
          @code = @project.gen_code(request.session_options[:id])
        else
          complete_flag = true
        end
      else
        # If project doesnt contain targets and we have already completed one, we will finish
        if @project.completed_count(request.session_options[:id]) > 0
          complete_flag = true
        else
          @code = @project.gen_code(request.session_options[:id])
        end
      end
    end

    if complete_flag == false
      # The following identifies what group "page" and individual should be on.
      # This will either be the branch, or the next logical group

      # Full branch logic
      if !@selected_branch.blank?
        @group = Group.find(@selected_branch[0].destination_group_id)
      else
        if !@branch.blank?
          @branch.return_group_id.blank? ? @group = @project.current_group(@code) : @group = Group.find(@selected_branch.return_group_id)
        else
          @group = @project.current_group(@code)
        end
      end
      # END branch logic

        if @group.blank?
          @code.update_attribute(:completed, true)
          next_flag = true
        else
          #@group = @project.current_group(@code, current_user)
          @questions = @group.questions.find(:all, :conditions => {"group_items.active" => true})
          @nancode = "NANCODE-#{@project.id}-#{@group.id}"

          # Is current group locked? If not then lock.
          @user_lock = UserLock.lock(@project, @group, @code, request.session_options[:id])
        end
    end

    #Redirection block, redirect or display group
    if next_flag
      if interstitial_flag
        redirect_to :controller => :projects, :action => :completed, :id => @project.id
      else
        redirect_to display_project_path(@project)
      end
    elsif complete_flag
        redirect_to :controller => :projects, :action => :completed, :id => @project.id
    else
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @project }
      end
    end

  end
  
  def assignuser
      @assigned_users = []
      @users = User.all
      #@users_roles = User.find_by_sql(["SELECT * FROM roles_users LEFT JOIN roles ON roles_users.role_id = roles.id WHERE roles.authorizable_type = 'Project' AND authorizable_id = ?", params[:id]])
      #@users_roles.collect{|x| @assigned_users << User.find(x.user_id)}
    if params[:role].nil?  
      @assigned_users = User.find_by_sql(["SELECT users.login, roles_users.user_id, roles_users.role_id, roles.name, roles.authorizable_type, roles.authorizable_id FROM users, roles_users LEFT JOIN roles ON roles_users.role_id = roles.id WHERE users.id = roles_users.user_id AND roles.authorizable_type = 'Project' AND roles.authorizable_id = ?", params[:id]])
      @project = Project.find(params[:id])
    else  
      @assigned_users = User.find_by_sql(["SELECT users.login, roles_users.user_id, roles_users.role_id, roles.name, roles.authorizable_type, roles.authorizable_id FROM users, roles_users LEFT JOIN roles ON roles_users.role_id = roles.id WHERE users.id = roles_users.user_id AND roles.authorizable_type = 'Project' AND roles.authorizable_id = ?", params[:project]])
      @project = Project.find(params[:project])
      user = User.find(params[:id])
      if params[:role_action] == "add"
        @project.accepts_role!(params[:role], user)
      elsif params[:role_action] == "remove"
        user.has_no_role!(params[:role], @project)
      end
    end  
  end

  # Method displays an inactive view of a project
  def display_preview
    @project = Project.find(params[:id])
    @code = @project.current_code(request.session_options[:id])
    @groups = ProjectItem.find(:all, :conditions => {:project_id => params[:id]}, :order => "position")
       
    #@nancode = "NANCODE-#{@project.id}-#{@group.id}"

    # Is current group locked? If not then lock.
    #@user_lock = UserLock.lock(@project, @group, request.session_options[:id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project }
    end

  end

  def completed
    @project = Project.find(params[:id])
  end
  
  def newuser
    @user = User.new
    @project = Project.find(params[:id])
  end
  
  def createuser
    @project = Project.find(params[:user][:project])
    params[:user].delete(:project)
    @user = User.new(params[:user])

    if @user.save_without_session_maintenance
      flash[:notice] = "Account registered!"
      @project.accepts_role!("user", @user)
      redirect_back_or_default projects_path
    else
      render :action => :newuser
    end
       
  end

  def select_branch(params, project_id, group_id)

      branches = Branch.find(:all, :conditions => {:project_id => project_id, :group_id => group_id})
      selected_branch = nil
      
      params.each_key do |key|
        nancode_array = key.split("-")
        if nancode_array[0] == "NANCODE"
          selected_branch = branches.select{|branch|
            (branch.project_id == nancode_array[1].to_i)  &&  (branch.group_id == nancode_array[2].to_i) && (branch.question_id == nancode_array[3].to_i ) && (branch.choice_id == params[key].to_i )
          }

          return selected_branch unless selected_branch.blank?
        end
      end

    return selected_branch
    
  end

end
