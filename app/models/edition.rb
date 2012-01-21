class Edition < ActiveRecord::Base
  class << self
    def find_isbn(isbn,sources=[])
      data=sources.map { |s|
        if r=s.find_isbn(isbn) then return self.new(r) end
      }
    end
  end
end
