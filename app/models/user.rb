class User < ActiveRecord::Base
  has_many :stories,:order=>"created_at desc"
  has_many :authorizations
  has_many :shelves,:order=>"name"
  has_many :collections
  has_many :books, :through => :collections
  has_many :borrowed_books, :class_name=>"Book", :foreign_key=>:borrower_id
  has_many :tags

  has_and_belongs_to_many :followers,:join_table=>:followlinks, 
  :class_name=>"User",
  :foreign_key=>:followed_id,
  :association_foreign_key=>:follower_id
  has_and_belongs_to_many :following,:join_table=>:followlinks, 
  :class_name=>"User",
  :foreign_key=>:follower_id,
  :association_foreign_key=>:followed_id


  def name
    "#{nickname} (#{fullname})"
  end

  def all_books
    books + borrowed_books
  end

  def tagnames
    Tagname.all(self)
  end

  def admin?
    false
  end
end
