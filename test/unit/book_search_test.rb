require "unit_test_helper"
require 'viewmodels/book_search'

MyBook ||= Class.new

describe BookSearch do
  it "searches for books" do
    mock(MyBook).where.with_any_args {
      mock("result").offset.with(0) {
        mock("result").limit.with(4) {
          Array.new(5,:book)
        }
      }
    }
    r = BookSearch.new(:start=>0, :end=>5, :class=>MyBook)
    rows = r.results
  end
end
