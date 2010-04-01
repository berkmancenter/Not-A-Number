class QuestionsController < ApplicationController

  before_filter :find_group, :form_symbol

  # GET /questions
  # GET /questions.xml
  def index
    @questions = Question.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.xml
  def show
    @question = Question.find(params[:id])
    @question_items = @question.question_items

    @available_choices = Choice.available_items(@question)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.xml
  def new
    @question = Question.new
    @source = params[:source]
    @meta_hash = Hash.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
    @meta_hash = ActiveSupport::JSON.decode(@question.meta) unless @question.meta.blank?
    @source = params[:source]
    
  end

  # POST /questions
  # POST /questions.xml
  def create
    @source = params[:source]
    meta_hash = Hash.new

    params[:question][:user_id] = current_user.id

    @question = Question.new(params[:question])
    @question.accepts_role!(:owner, current_user)

    if params[:type] == "QuestionTarget"
      meta_hash = Hash.new
      @question[:type] = "QuestionTarget"
      meta_hash[:behavior] = params[:behavior]
      meta_hash[:target_list_id] = params[:target_list_id]
      @question[:meta] = meta_hash.to_json
    else
      @question[:type] = params[@form_symbol][:type]
    end
    

    if @group
      GroupItem.create({:group_id => @group.id,
          :question_id => @question.id,
          :user_id => current_user.id
        })
    end

    
    respond_to do |format|
      if @question.save
        flash[:notice] = 'Question was successfully created.'
        format.html { redirect_to(:back) }
        format.xml  { render :xml => @question, :status => :created, :location => @question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.xml
  def update
    @question = Question.find(params[:id])
    @source = params[:source]

    if params[:type] == "QuestionTarget"
      meta_hash = Hash.new
      @question[:type] = "QuestionTarget"
      meta_hash[:behavior] = params[:behavior]
      meta_hash[:target_list_id] = params[:target_list_id]
      @question[:meta] = meta_hash.to_json
    else
      @question[:type] = params[@form_symbol][:type]
    end

    respond_to do |format|
      if @question.update_attributes(params[@form_symbol])
        flash[:notice] = 'Question was successfully updated.'

          format.html { redirect_to(:back) }
          format.xml  { render :xml => @question, :status => :created, :location => @question }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.xml
  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to(:back) }
      format.xml  { head :ok }
    end
  end

  def import
    @file = params[:upload][:datafile] unless params[:upload].blank?
    @question = Question.find(params[:id])
    
    unless @file.nil?
      @csv_array = FasterCSV.parse(@file.read)

      @csv_array.each do |row|
        choice = Choice.create({
          :title => row[0],
          :output_text => row[1],
          :description => row[2]
          })
        choice.accepts_role!(:owner, current_user)

        @question.choices << choice
      end

      redirect_to question_path(@question)

    end

  end

  private

  def find_group
    @group = Group.find(params[:parent_id]) unless params[:parent_id].blank?
  end

  def form_symbol
     if params[:question_autocomplete_choice] then @form_symbol = :question_autocomplete_choice end
     if params[:question_target] then @form_symbol = :question_target end
     if params[:question_text] then @form_symbol = :question_text end
     if params[:question_text_area] then @form_symbol = :question_text_area end
     if params[:question_radio] then @form_symbol = :question_radio end
     if params[:question_checkbox] then @form_symbol = :question_checkbox end
     if params[:question_drop_down] then @form_symbol = :question_drop_down end
     if params[:question_note] then @form_symbol = :question_note end
     if params[:question] then @form_symbol = :question end

  end

end
