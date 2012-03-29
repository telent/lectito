class Collection < ActiveRecord::Base
  belongs_to :user
  has_many :books
  has_many :memberships
  has_many :users, :through=>:memberships
end
