class Edition < ActiveRecord::Base
  validates :title, :presence=>true
  validates :author, :presence=>true
  has_many :books

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
