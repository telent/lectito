class CollectionsController < ApplicationController
  def index
    @user = if uid=params[:user_id] then
              UserDecorator.find(uid)
            else
              current_user
            end
    respond_with @collections=@user.collections
  end
  def show
    @collection=CollectionDecorator.find(params[:id])
    @user=@collection.user
    respond_with @collection
  end
end
