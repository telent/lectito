require 'test_helper'

describe Edition do
  it "has title, author, publisher attributes" do
    @e=Edition.create
    [:title,:author,:publisher].each do |att|
      assert @e.respond_to? att
    end
  end
  it "finds data from external sources if it can't find ISBN" do
    isbn="9-780553-586251"
    # all it really does is delegate to the source
    mock(source=Object.new).find_isbn(isbn) { {
        :title=>"Spin Control",
        :author=>"Chris Moriarty",
        :publisher=>"Spectra"
      } }
    e=Edition.find_isbn(isbn, [source])
    assert_equal "Spin Control",e.title
    assert_equal "Chris Moriarty",e.author
    assert_equal "Spectra", e.publisher
  end
  it "returns nil if no isbn found" do
    isbn="9-780553-586251"
    # all it really does is delegate to the source
    mock(source=Object.new).find_isbn(isbn) { nil }
    e=Edition.find_isbn(isbn, [source])
    e.must_be_nil
  end
  describe "books" do
    before do
      @e=Edition.create(:title=>"Spin Control",
                       :author=>"Chris Moriarty",
                       :publisher=>"Spectra"
                       ) 
      shelf = Shelf.create(name: 'lll')
      @u1=User.create
      @u2=User.create
      @b1=Book.create(:edition=>@e,:home_shelf=>shelf,:collection=>@u1.public_collection)   
      @b2=Book.create(:edition=>@e,:home_shelf=>shelf,:collection=>@u2.public_collection)
    end
    it "has books" do
      assert_equal [@b1,@b2].map(&:id).to_set, @e.books.map(&:id).to_set
    end
    it "finds books visible to given user" do
      b3= Book.create(:edition=>@e,
                      :home_shelf=>Shelf.create(name: 'lll'),
                      :collection=>@u1.private_collection)
      assert_equal [@b1,@b2,b3].to_set, @e.books.for_user(@u1).to_set
      assert_equal [@b1,@b2].to_set, @e.books.for_user(@u2).to_set
    end
  end
end
