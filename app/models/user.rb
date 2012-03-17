class User < ActiveRecord::Base
  has_many :stories,:order=>"created_at desc"
  has_many :authorizations
  has_many :shelves,:order=>"name"
  has_many :collections
  has_many :books, :through => :collections
  has_many :borrowed_books, :class_name=>"Book", :foreign_key=>:borrower_id
  has_many :tags

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
