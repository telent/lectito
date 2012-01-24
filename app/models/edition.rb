class Edition < ActiveRecord::Base
  class << self
    def find_isbn(isbn,sources=EditionSources)
      data=sources.map { |s|
        if r=s.find_isbn(isbn) then return self.create(r) end
      }
      nil
    end
  end
end
