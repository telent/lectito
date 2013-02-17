class IdentityMappedBookSearch
  def initialize(args)
    a=args.dup
    @class = a.delete(:class) || Book
    @start = a.delete(:start) || 0
    @end = (e=a.delete(:end)) ? (e-1) : nil
    @where = {}
    @user = a.delete(:user)
    c_ids = (a.delete(:collection_ids) || []) +
      (a.delete(:collections) || []).map(&:id)
    @where[:collection_id] = c_ids unless c_ids.empty?
    s_ids = (a.delete(:shelf_ids) || []) +
      (a.delete(:shelves) || []).map(&:id)
    @where[:current_shelf_id] = s_ids unless s_ids.empty?
  end

  def row_mapper book
    book
  end

  def results
    results = @class.where(@where).offset(@start).limit(@end)
    results.map {|r| row_mapper(r) }
  end

end

class BookSearch < IdentityMappedBookSearch
  def row_mapper book
    loc = case 
          when book.owned_by?(@user) && !book.on_loan? then
            book.current_shelf.name
          when book.owned_by?(@user) && book.on_loan? then
            book.borrower.name
          else "sdfgsdfg"
          end
    { 
      location: loc
    }
  end

end
