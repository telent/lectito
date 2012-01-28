class ShelvesController < ApplicationController
  def index
    @shelves=current_user.shelves
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shelves }
    end
  end
end

