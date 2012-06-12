class Edition < ActiveRecord::Base
  validates :title, :presence=>true
  validates :author, :presence=>true
  has_many :books do
    def for_user(user)
      self.where(:collection_id=>Collection.visible_for(user))
    end
  end
  has_many :tags

  class << self
    def find_isbn(isbn,sources=EditionSources)
      n=self.where(:isbn=>isbn).first
      if n then return n end
      sources.map { |s|
        if r=s.find_isbn(isbn) then return self.create(r) end
      }
      nil
    end
  end
end
