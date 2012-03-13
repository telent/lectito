class ShelvesController < ApplicationController
  def index
    respond_with @shelves=current_user.shelves
  end
  def show
    respond_with @shelf=Shelf.find(params[:id])
  end
  def add_books
    @shelf=Shelf.find(params[:id])
    Book.find(params[:book_ids].split(",").map(&:to_i)).each do |b|
      b.reshelve @shelf
    end
    respond_with @shelf
  end
end

