class TargetListsController < ApplicationController
  # GET /target_lists
  # GET /target_lists.xml
  def index
    @target_lists = TargetList.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @target_lists }
    end
  end

  # GET /target_lists/1
  # GET /target_lists/1.xml
  def show
    @target_list = TargetList.find(params[:id])
    @target_list_items = @target_list.target_list_items

    @available_target_items = Target.available_items(@target_list)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @target_list }
    end
  end

  # GET /target_lists/new
  # GET /target_lists/new.xml
  def new
    @target_list = TargetList.new
    @source = params[:source]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @target_list }
    end
  end

  # GET /target_lists/1/edit
  def edit
    @target_list = TargetList.find(params[:id])
    @source = params[:source]
  end

  # POST /target_lists
  # POST /target_lists.xml
  def create
    @target_list = TargetList.new(params[:target_list])
    @source = params[:source]
    
    @target_list.accepts_role!(:owner, current_user)

    respond_to do |format|
      if @target_list.save
        flash[:notice] = 'TargetList was successfully created.'
        format.html { redirect_to(:back) }
        format.xml  { render :xml => @target_list, :status => :created, :location => @target_list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @target_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /target_lists/1
  # PUT /target_lists/1.xml
  def update
    @target_list = TargetList.find(params[:id])

    respond_to do |format|
      if @target_list.update_attributes(params[:target_list])
        flash[:notice] = 'TargetList was successfully updated.'
        format.html { redirect_to(:back) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @target_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /target_lists/1
  # DELETE /target_lists/1.xml
  def destroy
    @target_list = TargetList.find(params[:id])
    @target_list.destroy

    respond_to do |format|
      format.html { redirect_to(:back) }
      format.xml  { head :ok }
    end
  end
  
  def import
    @file = params[:upload][:datafile] unless params[:upload].blank?
    @target_list = TargetList.find(params[:id])
    
    unless @file.nil?
      @csv_array = FasterCSV.parse(@file.read)

      @csv_array.each do |row|
        target = Target.create({
          :title => row[0],
          :output_text => row[1],
          :description => row[2],
          :content => row[3]
          })
        target.accepts_role!(:owner, current_user)

        @target_list.targets << target
      end

      redirect_to target_list_path(@target_list)

    end

  end
end
