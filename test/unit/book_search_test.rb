require "unit_test_helper"
require 'viewmodels/book_search'

MyBook ||= Class.new

describe BookSearch do
  it "searches for books" do
    mock(MyBook).where(hash_including(collection_id: [1,3],
                                      current_shelf_id: [7],
                                      )).mock!.
      offset(0).mock!.limit(4) {
      Array.new(5,:book)
    }
    r = BookSearch.new(:start=>0, :end=>5, :class=>MyBook,
                       :collection_ids => [1,3],
                       :shelves => [OpenStruct.new(id: 7 )])
    rows = r.results
  end
  it "does not search by collection unless collections supplied" do
    mock(MyBook).where(satisfy{|a| a[:current_shelf_id] && !a[:collection_id]}).
      mock!.offset(0).mock!.limit(4) {
      Array.new(5,:book)
    }
    r = BookSearch.new(:start=>0, :end=>5, :class=>MyBook,
                       :shelves => [OpenStruct.new(id: 7 )])
    rows = r.results
    
  end
end
