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
    current_shelf.nil? || (current_shelf==home_shelf)
  end

  def on_loan?
    !! self.borrower
  end

  def location 
    case 
    when home? then ""
    when on_loan? 
    then [current_shelf.user.nickname,current_shelf.name].join(" / ")
    else current_shelf.name
    end
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
