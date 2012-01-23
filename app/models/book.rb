class Book < ActiveRecord::Base
  belongs_to :owner, :class_name=>"User"
  belongs_to :borrower, :class_name=>"User"
  belongs_to :home_shelf, :class_name=>"Shelf"
  belongs_to :current_shelf, :class_name=>"Shelf"
  belongs_to :edition
end
