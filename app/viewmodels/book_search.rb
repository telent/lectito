class BookSearch
  def initialize(args)
    a=args.dup
    @class = a.delete(:class) || Book
    @start = a.delete(:start) || 0
    @end = (e=a.delete(:end)) ? (e-1) : nil
    @where = {}
    c_ids = (a.delete(:collection_ids) || []) +
      (a.delete(:collections) || []).map(&:id)
    @where[:collection_id]= c_ids unless c_ids.empty?
    s_ids = (a.delete(:shelf_ids) || []) +
      (a.delete(:shelves) || []).map(&:id)
    @where[:current_shelf_id] = s_ids
  end
  def results
    return @class.where(@where).offset(@start).limit(@end)
  end
end
