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
    # all it really does is delegate to the source
    source=MiniTest::Mock.new
    isbn="9-780553-586251"
    ret={:title=>"Spin Control",
      :author=>"Chris Moriarty",
      :publisher=>"Spectra"}
    source.expect(:find_isbn,ret,[isbn])
    e=Edition.find_isbn("9-780553-586251", [source])
    assert_equal "Spin Control",e.title
    assert_equal "Chris Moriarty",e.author
    assert_equal "Spectra", e.publisher
  end
end
