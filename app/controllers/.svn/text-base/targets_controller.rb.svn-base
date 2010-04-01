class TargetsController < ApplicationController

  before_filter :find_target_list
  
  # GET /targets
  # GET /targets.xml
  def index
    @targets = Target.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @targets }
    end
  end

  # GET /targets/1
  # GET /targets/1.xml
  def show
    @target = Target.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @target }
    end
  end

  # GET /targets/new
  # GET /targets/new.xml
  def new
    @target = Target.new
    @source = params[:source]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @target }
    end
  end

  # GET /targets/1/edit
  def edit
    @target = Target.find(params[:id])
    @source = params[:source]
  end

  # POST /targets
  # POST /targets.xml
  def create
    params[:target][:user_id] = current_user.id

    @target = Target.new(params[:target])
    @source = params[:source]

    @target.accepts_role!(:owner, current_user)

    if @target_list
    TargetListItem.create({:target_list_id => @target_list.id,
      :target_id => @target.id,
      :user_id => current_user.id
    })
    end

    respond_to do |format|
      if @target.save
        flash[:notice] = 'Target was successfully created.'
        format.html { redirect_to(:back) }
        format.xml  { render :xml => @target, :status => :created, :location => @target }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @target.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /targets/1
  # PUT /targets/1.xml
  def update
    @target = Target.find(params[:id])

    respond_to do |format|
      if @target.update_attributes(params[:target])
        flash[:notice] = 'Target was successfully updated.'
        format.html { redirect_to(:back) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @target.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /targets/1
  # DELETE /targets/1.xml
  def destroy
    @target = Target.find(params[:id])
    @target.destroy

    respond_to do |format|
      format.html { redirect_to(:back) }
      format.xml  { head :ok }
    end
  end

  private

  def find_target_list
    @target_list = TargetList.find(params[:parent_id]) unless params[:parent_id].blank?
  end
end
