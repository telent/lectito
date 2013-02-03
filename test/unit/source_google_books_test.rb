require 'test_helper'

describe EditionSource::GoogleBooks do
  it "finds by ISBN" do
    response_body=File.read(File.join(File.dirname(__FILE__),"data/spincontrol.json"))
    isbn="9-780553-586251"
    s=Patron::Session.new
    mock(Patron::Session).new { s }
    mock(s).get.with_any_args { 
      OpenStruct.new(:status=>200,:body=>response_body) 
    }

    source = EditionSource::GoogleBooks.new
    ret=source.find_isbn(isbn)
    assert_equal "Spin Control",ret[:title]
    assert_equal "Chris Moriarty",ret[:author]
    assert_equal "Spectra", ret[:publisher]
  end
end
