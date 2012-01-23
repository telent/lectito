class BooksController < ApplicationController
  def index
  end
  def new
    @book=Book.new
    @edition=Edition.new
    @shelves=current_user.shelves
    @collections=current_user.collections
  end
  def create
  end
end
