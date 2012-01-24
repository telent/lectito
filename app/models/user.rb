class User < ActiveRecord::Base
  has_many :stories,:order=>"created_at desc"
  has_many :authorizations
  has_many :shelves
  has_many :collections
  has_many :books, :through => :collections

  def name
    "#{nickname} (#{fullname})"
  end
end
