class Book < ActiveRecord::Base
  extend Forwardable
#  belongs_to :owner, :class_name=>"User"
#  belongs_to :borrower, :class_name=>"User"
  belongs_to :home_shelf, :class_name=>"Shelf"
  belongs_to :current_shelf, :class_name=>"Shelf"
  belongs_to :collection
  belongs_to :edition
  
  def_delegators :edition, :title, :author, :publisher, :isbn

  def home?
    (current_shelf==home_shelf)
  end

  def on_loan?
    current_shelf.user != collection.user
  end


end
