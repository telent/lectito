class CollectionsController < ApplicationController
  def index
    @user = if uid=params[:user_id] then
              User.find(uid)
            else
              current_user
            end
    respond_with @collections=@user.collections
  end
  def show
    respond_with @collection=Collection.find(params[:id])
  end
end
