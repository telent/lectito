require "unit_test_helper"
require 'viewmodels/book_search'

MyBook ||= Class.new

describe BookSearch do
  it "searches for books" do
    mock(MyBook).where(hash_including(collection_ids: [1,3],
                                      shelf_ids: [7],
                                      )) {
      mock("result").offset(0) {
        mock("result").limit(4) {
          Array.new(5,:book)
        }
      }
    }
    r = BookSearch.new(:start=>0, :end=>5, :class=>MyBook,
                       :collection_ids => [1,3],
                       :shelves => [OpenStruct.new(id: 7 )])
    rows = r.results
  end
end
