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
    # if there's no data for the edition, look it up
    # if there's no edition found, add a validation error
    # if there's title/author/publisher, create an edition
    # create a book that refers to it
    b=params[:book]
    e=params[:edition]
    if [:title,:author,:publisher].map{|f| e[f].present? }.any? then
      @edition=Edition.new(e)
    else
      @edition=Edition.find_isbn(e[:isbn])
    end
    @book=Book.new(b,:owner=>current_user)
    if @edition 
      @edition.books << @book
      if @edition.save && @book.save
        flash.notice =
          "Added #{@edition.author}, &ldquo;#{@edition.title}&rdquo;"
        redirect_to :action=>:new
      end
    end
    if @edition.nil? then
      @edition=Edition.new(:isbn=>e[:isbn])
      @edition.errors[:isbn] << "not found, please add full publication details"
    end
    if @book.new_record?
      @shelves=current_user.shelves
      @collections=current_user.collections
      render action: :new
    end
  end
end
