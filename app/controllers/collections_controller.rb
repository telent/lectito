class CollectionsController < ApplicationController
  def index
    respond_with @collections=current_user.collections
  end
  def show
    respond_with @collection=Collection.find(params[:id])
  end
  def add_books
    @collection=Collection.find(params[:id])
    Book.find(params[:book_ids]).each do |b|
      b.collection=@collection
      b.save
    end
  end
end
