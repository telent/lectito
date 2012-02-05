class CollectionsController < ApplicationController
  def index
    respond_with @collections=current_user.collections
  end
  def show
    respond_with @collection=Collection.find(params[:id])
  end
end
