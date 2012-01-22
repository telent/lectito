require 'test_helper'
require 'pp'

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
end
