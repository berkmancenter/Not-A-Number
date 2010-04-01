class BranchesController < ApplicationController
  include ActionView::Helpers::FormOptionsHelper

  # GET /branches
  # GET /branches.xml
  def index
    @branches = Branch.find(:all, :conditions => {:group_id => params[:group_id]})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @branches }
    end
  end

  # GET /branches/1
  # GET /branches/1.xml
  def show
    @branch = Branch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @branch }
    end
  end

  # GET /branches/new
  # GET /branches/new.xml
  def new
    @branch = Branch.new
    @source = params[:source]
    @project_id = params[:project_id]
    @group_id = params[:group_id]
    @group = Group.find(params[:group_id])
    @project = Project.find(params[:project_id])
    @qtypes = ["QuestionRadio", "QuestionCheckbox", "QuestionDropDown"]
    @group_items = @group.questions.find(:all, :conditions => {:type => @qtypes}).collect{|q| [q.output_text, q.id]}
    p @group_items
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @branch }
    end
  end
  
  def get_choices
    question_item_choices = QuestionItem.find(:all, :conditions => {:question_id => params[:question_id]})
    choices_array = Array.new
    question_item_choices.each {|item| choices_array << [item.choice.output_text, item.choice.id]}
    
    choices_output = ""
    choices_output += options_for_select choices_array

    respond_to do |format|
      format.js {render :text => choices_output, :layout => nil}
    end
  end

  # GET /branches/1/edit
  def edit
    @branch = Branch.find(params[:id])
    @source = params[:source]
    @group = Group.find(@branch.group_id)
  end

  # POST /branches
  # POST /branches.xml
  def create
    params[:branch][:group_id] = params[:group_id]
    params[:branch][:project_id] = params[:project_id]
    @branch = Branch.new(params[:branch])
    
    respond_to do |format|
      if @branch.save
        flash[:notice] = 'Branch was successfully created.'
        format.html { redirect_to(:back) }
        format.xml  { render :xml => @branch, :status => :created, :location => @branch }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @branch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /branches/1
  # PUT /branches/1.xml
  def update
    @branch = Branch.find(params[:id])

    respond_to do |format|
      if @branch.update_attributes(params[:branch])
        flash[:notice] = 'Branch was successfully updated.'
        format.html { redirect_to(:back) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @branch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /branches/1
  # DELETE /branches/1.xml
  def destroy
    @branch = Branch.find(params[:id])
    @branch.destroy

    respond_to do |format|
      format.html { redirect_to(branches_url) }
      format.xml  { head :ok }
    end
  end
end
