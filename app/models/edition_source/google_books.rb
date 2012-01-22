module EditionSource
  class GoogleBooks
    def initialize
      @patron=Patron::Session.new
      @patron.base_url="https://www.googleapis.com/"
    end

    def find_by_isbn(isbn)
      isbn=isbn.gsub(/[^\d]/,"")
      r=@patron.get("/books/v1/volumes?q=isbn:#{isbn}")
      if (r.status==200) then
        data=JSON.parse(r.body)
        if(data["totalItems"].to_i > 0) then
          v=data["items"][0]["volumeInfo"]
          Hash[publisher: v["publisher"],
               title: v["title"],
               author: v["authors"].join(", "),
               isbn: isbn]
        end
      end
    end
  end
end
