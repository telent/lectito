module EditionSource
  class GoogleBooks
    def find_isbn(isbn)
      @patron = Patron::Session.new 
      @patron.connect_timeout = 5000
      @patron.base_url="https://www.googleapis.com/"
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
