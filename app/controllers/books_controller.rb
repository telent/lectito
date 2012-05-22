class BooksController < ApplicationController
  def books_for_params(user,params)
    books=user.books.joins(:edition)
    case (s=params[:sort] and s.to_sym)
    when :title,:author,:publisher,:isbn
    then
      books=books.order(s.to_s)
    when :location
      # this is a PITA
      # if book is at home, sort by name of shelf
      # if book is lent, sort by name of borrower
      books=books # XXX fix this
    else
      books=books.order(:created_at)
    end
    if /\Ad/.match(params[:direction]) then
      books=books.reverse_order
    end
    books
  end
  private :books_for_params

  def index
    check_authorized { current_user }
    @books=books_for_params(current_user,params)
    p=Integer(params[:page] || 1)
    @books=@books.offset((p-1)*20).limit(21) 
    @shelves=current_user.shelves.sort_by(&:name)
    @collections=current_user.collections.sort_by(&:name)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books.to_json(include: :edition) }
    end
  end

  def count
    check_authorized { current_user }
    num=books_for_params(current_user,params).count
    respond_to do |format|
      format.html
      format.json { render json: {count: num}}
    end
  end

  def new
    @book=Book.new
    @edition=Edition.new
    @shelves=current_user.shelves
    @collections=current_user.collections
  end

  def edit
    @book=Book.find(params[:id])
    @edition=@book.edition
    @shelves=current_user.shelves
    @collections=current_user.collections
  end

  # XXX need an update method.

  # 
  def post_attribute(method,model)
    book=Book.find(params[:id])
    yield book
    book.send(method,model.find(params[:value]))
    respond_to do |format|
      format.html { redirect_to :action=>:show }
      format.json {
        response.headers["Content-Location"] = url_for(book)
        render json: book
      }
    end
  end

  def shelf
    post_attribute :reshelve,Shelf do |book|
      check_authorized { 
        (book.owner == current_user) ||
        (book.borrower == current_user) 
      }
    end
  end

  def collection
    post_attribute :collection=,Collection do |book|
      check_authorized { 
        (book.owner == current_user) 
      }
    end
  end

  def tag
    post_attribute :tag,Tagname do |book|
      # anyone can tag any book
      true
    end
  end

  def lend
    book=Book.find(params[:id])
    check_authorized { book.owner == current_user }
    book.lend(User.find(params[:borrower_id]))
    respond_to do |format|
      format.html { redirect_to :action=>:show}
      format.json { render json: book }
    end
  end

  def return
    book=Book.find(params[:id])
    check_authorized { book.owner == current_user }
    book.return
    respond_to do |format|
      format.html { redirect_to :action=>:show}
      format.json { render json: book }
    end
  end

  def show
    check_authorized { current_user }
    @book=Book.find(params[:id])
    respond_to do |format|
      format.html 
      format.json { render json: @book }
    end
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

  def breadcrumb
    @breadcrumbs=[["library",books_path]]
  end
end
