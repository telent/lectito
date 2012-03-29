class CollectionsController < ApplicationController
  def index
    @collections=
      if uid=params[:user_id] then
        User.find(uid).collections
      else
        current_user.collections
      end
    respond_with @collections
  end
  def show
    respond_with @collection=Collection.find(params[:id])
  end
end
