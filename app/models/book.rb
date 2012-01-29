class Book < ActiveRecord::Base
  extend Forwardable
  belongs_to :home_shelf, :class_name=>"Shelf"
  belongs_to :current_shelf, :class_name=>"Shelf"
  belongs_to :borrower, :class_name=>"User"
  belongs_to :collection
  belongs_to :edition
  
  def_delegators :edition, :title, :author, :publisher, :isbn

  def owner
    self.collection.user
  end
  
  def home?
    # current_shelf may be nil if the book has been loaned and the 
    # recipient has not decided where to put it, or if the book is
    # on its home shelf
    (current_shelf.nil? && !on_loan?) || (current_shelf==home_shelf)
  end

  def on_loan?
    borrower && (borrower!=owner)
  end

  def location 
    case 
    when home? then ""
    when on_loan? 
    then [current_shelf.user.nickname,current_shelf.name].join(" / ")
    else current_shelf.name
    end
  end

  def reshelve(shelf)
    if on_loan? then
      self.current_shelf=shelf
    else
      self.home_shelf=shelf
    end
    save
  end

  def lend(borrower)
    if self.on_loan? then
      raise Exception,"Can't loan to two people at once"
    elsif borrower==self.owner then
      raise Exception,"Can't lend to owner"
    else
      self.borrower=borrower
      self.current_shelf=nil
      Event.publish(:actor=>self.owner,:action=>:lend,:recipient=>borrower,
                    :book=>self)
      save
    end
  end

  def return
    b=self.borrower
    self.borrower=nil
    self.save
    Event.publish(:actor=>b,:action=>:return,:book=>self)
  end

end
