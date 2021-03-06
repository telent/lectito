class LinksController < ApplicationController
  # GET /links
  # GET /links.json
  def index
    @user = UserDecorator.find(params[:user_id])
    @links = @user.links

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @links }
    end
  end

  # GET /links/1
  # GET /links/1.json
  def show
    @user = UserDecorator.decorate User.find(params[:user_id])
    @link = @user.links.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @link }
    end
  end

  # GET /links/new
  # GET /links/new.json
  def new
    @user = UserDecorator.find(params[:user_id])
    @link = @user.links.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @link }
    end
  end

  # GET /links/1/edit
  def edit
    u = User.find(params[:user_id])
    @user = UserDecorator.new u
    @link = u.links.find(params[:id])
  end

  # POST /links
  # POST /links.json
  def create
    @user = UserDecorator.find(params[:user_id])
    @link = @user.links.build(params[:link])

    respond_to do |format|
      if @link.save
        format.html { redirect_to user_links_path(@user), notice: 'Link was successfully created.' }
        format.json { render json: @link, status: :created, location: @link }
      else
        format.html { render action: "new" }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:user_id])
    @link = @user.links.find(params[:id])

    respond_to do |format|
      if @link.update_attributes(params[:link])
        format.html { redirect_to user_links_path(@user), notice: 'Link was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @user = User.find(params[:user_id])
    @link = @user.links.find(params[:id])
    @link.destroy

    respond_to do |format|
      format.html { redirect_to user_links_path(@user), notice: 'Link was successfully deleted.' }
      format.json { head :no_content }
    end
  end
end
