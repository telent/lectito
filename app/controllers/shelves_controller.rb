class ShelvesController < ApplicationController
  def index
    respond_with @shelves=current_user.shelves
  end
  def show
    respond_with @shelf=Shelf.find(params[:id])
  end

end

