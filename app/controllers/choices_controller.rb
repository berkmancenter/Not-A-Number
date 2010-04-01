class ChoicesController < ApplicationController

  before_filter :find_question

  # GET /choices
  # GET /choices.xml
  def index
    @choices = Choice.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @choices }
    end
  end

  # GET /choices/1
  # GET /choices/1.xml
  def show
    @choice = Choice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @choice }
    end
  end

  # GET /choices/new
  # GET /choices/new.xml
  def new
    @choice = Choice.new
    @source = params[:source]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @choice }
    end
  end

  # GET /choices/1/edit
  def edit
    @choice = Choice.find(params[:id])
    @source = params[:source]
  end

  # POST /choices
  # POST /choices.xml
  def create
    @source = params[:source]

    params[:choice][:user_id] = current_user.id

    @choice = Choice.new(params[:choice])
    @choice.accepts_role!(:owner, current_user)

    if @question && @choice.save
      QuestionItem.create({:question_id => @question.id,
          :choice_id => @choice.id,
          :user_id => current_user.id
        })
    end

    respond_to do |format|
      if @choice.save
        flash[:notice] = 'Choice was successfully created.'
        format.html { redirect_to(:back) }
        format.xml  { render :xml => @choice, :status => :created, :location => @choice }
      else
        format.html {
        render :update do |page|
          page.replace_html :modal_error_message, "hello"
        end
        }
        #format.html { redirect_to(:back) }
        format.xml  { render :xml => @choice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /choices/1
  # PUT /choices/1.xml
  def update
    @choice = Choice.find(params[:id])
    @source = params[:source]

    respond_to do |format|
      if @choice.update_attributes(params[:choice])
        flash[:notice] = 'Choice was successfully updated.'
        format.html { redirect_to(:back) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @choice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /choices/1
  # DELETE /choices/1.xml
  def destroy
    @choice = Choice.find(params[:id])
    @choice.destroy

    respond_to do |format|
      format.html { redirect_to(:back) }
      format.xml  { head :ok }
    end
  end

  def find_question
    @question = Question.find(params[:parent_id]) unless params[:parent_id].blank?
  end

end
