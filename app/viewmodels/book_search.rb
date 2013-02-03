class BookSearch
  def initialize(args)
    a=args.dup
    @class = a.delete(:class) || Book
    @start = a.delete(:start) || 0
    @end = (e=a.delete(:end)) ? (e-1) : nil
  end
  def results
    return @class.where(@where).offset(@start).limit(@end)
  end
end
