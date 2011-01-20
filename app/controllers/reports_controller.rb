class ReportsController < ApplicationController
  # GET /reports
  # GET /reports.xml
    
  def index
    #@reports = Report.all
    @projects = Project.all
    @projecids = @projects.collect {|p| p.title}
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reports }
    end
  end

  # GET /reports/1
  # GET /reports/1.xml
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @report }
    end
  end

  # GET /reports/new
  # GET /reports/new.xml
  def new

    #@report = Report.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report }
    end
  end

  # GET /reports/1/edit
  def edit
    #@report = Report.find(params[:id])
  end

  # POST /reports
  # POST /reports.xml
  def create

   #@report = Report.new(params[:report])

    respond_to do |format|
      if @report.save
        flash[:notice] = 'Report was successfully created.'
        format.html { redirect_to(@report) }
        format.xml  { render :xml => @report, :status => :created, :location => @report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reports/1
  # PUT /reports/1.xml
  def update
    #@report = Report.find(params[:id])

    respond_to do |format|
      if @report.update_attributes(params[:report])
        flash[:notice] = 'Report was successfully updated.'
        format.html { redirect_to(@report) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.xml
  def destroy
    #@report = Report.find(params[:id])
    #@report.destroy

    respond_to do |format|
      format.html { redirect_to(reports_url) }
      format.xml  { head :ok }
    end
  end

  def display
    @project = Project.find(params[:project_id])
    @groups = @project.groups
    @codes = @project.codes.find(:all, :conditions => {:completed => true})
    
    @group_items = Array.new
    
    @groups.each do |group|
      @group_items += group.group_items
    end

    @question_ids = @group_items.collect {|group_item|
      question_text = "\"#{group_item.question_id.to_s} - \'#{group_item.question.title}\'\""
      @group_items.last == group_item ? question_text : question_text + "," }

    @question_ids << 8
    @question_ids << 37

    @report_content = "user_id,user_name,code_id,#{@question_ids},date_saved\n"

    @codes.each do |code|
      answers_array = Array.new

      @group_items.each do |group_item|
        @nancode = "NANCODE-#{@project.id}-#{group_item.group_id}"

#        if group_item.question.type == "QuestionCheckbox"
#          answer = "\"#{CGI.escapeHTML answer_value.inspect.gsub('"',"'")}\""
#        elsif group_item.question.type == "QuestionRadio"
#          answer = "\"#{CGI.escapeHTML answer_record.answer_data}\""
#        elsif group_item.question.type == "QuestionRadio"
#          answer = "\"#{CGI.escapeHTML answer_record.answer_data}\""
#        else
#          answer = "\"#{CGI.escapeHTML answer_value}\""
#        end

        answer = group_item.question.report_data(code, @nancode)

        if @group_items.last != group_item then answer += "," end
        answers_array << answer
      end
      
      @report_content += "#{code.user_id},\"#{code.user.login}\",#{code.id},#{answers_array},#{code.updated_at}\n"

      response.headers['Content-Type'] = 'text/csv; charset=iso-8859-1; header=present'
      filename = "attachment; filename=#{@project.title}.csv"
      response.headers['Content-Disposition'] = filename

    end
  end
  
  def displayCompleted
    @parameters = params[:completed]
    @projectid = Project.find(:first, :conditions => {:title => @parameters[:project]})
    @completedCount = Code.find_by_sql(["select users.login, count(codes.code) as tally from users, codes where users.id = codes.user_id and codes.project_id=? group by codes.user_id", @projectid.id])
  end
  
  def similar
    require 'open-uri'
    require 'cobravsmongoose'
    
    @parameters = params[:similar]
    @projectid = Project.find(:first, :conditions => {:title => @parameters[:project]})
    @answers = Answer.find(:all, :conditions => {:question_id => 13, :project_id => @projectid})
    @artists = []
    @URLs = []
    @answers.each do |a|
      a.answer_data.split(',').each {|a| @artists << a.lstrip}
    end
    p @artists
    
    @artists.each do |art|
      @URLs << "http://ws.audioscrobbler.com/2.0/?method=artist.getsimilar&artist=#{art}&api_key=b25b959554ed76058ac220b7b2e0a026"
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reports }
    end
  end
  
  def counts
    @clustercounts = Report.find_by_sql(["select clu35,q95,count(q95) as tally from zzzz_data_clusters group by clu35,q95;"])
    @choices = {:q95 => ["Yes", "No", "Don't Know/Can't Tell"], :q17 => [88, 143, 160, 163, 173, 184, 343, 344, 356], :q18 => [198, 199, 200, 201, 346, 357], :q69 => ["Yes", "No", "Don't Know"], :q20 => ["Male", "Female", "Don't Know/Group Blog"]}
    p "data"
    p @clustercounts[0].class
    
    
  end

end
