class Book < ActiveRecord::Base
  belongs_to :owner
  belongs_to :borrower
  belongs_to :current_shelf
  belongs_to :edition
end
