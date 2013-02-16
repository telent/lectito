require "unit_test_helper"
require 'viewmodels/book_search'

MyBook ||= Class.new

describe BookSearch do
  let :book do
    OpenStruct.new(title: "Hello World",
                   current_shelf: OpenStruct.new(name: 'my shelf'))
  end
  it "searches for books" do
    mock(MyBook).where(hash_including(collection_id: [1,3],
                                      current_shelf_id: [7],
                                      )).mock!.
      offset(0).mock!.limit(4) {
      Array.new(5,book)
    }
    r = IdentityMappedBookSearch.new(:start=>0, :end=>5, :class=>MyBook,
                                     :collection_ids => [1,3],
                                     :shelves => [OpenStruct.new(id: 7 )])
    rows = r.results
  end

  it "does not search by collection unless collections supplied" do
    mock(MyBook).where(satisfy{|a| a[:current_shelf_id] && !a[:collection_id]}).
      mock!.offset(0).mock!.limit(4) {
      Array.new(5,book)
    }
    r = IdentityMappedBookSearch.new(:start=>0, :end=>5, :class=>MyBook,
                                     :shelves => [OpenStruct.new(id: 7 )])
    rows = r.results
  end

  it "does not search by shelf unless shelves supplied" do
    mock(MyBook).where(satisfy{|a| !a[:current_shelf_id] && a[:collection_id]}).
      mock!.offset(0).mock!.limit(4) {
      Array.new(5,book)
    }
    r = IdentityMappedBookSearch.new(:start=>0, :end=>5, :class=>MyBook,
                                     :collection_ids => [1,3]
                                     )
    rows = r.results
  end
  
  describe "#location" do
    before do
      stub(MyBook).where.stub!.offset.stub!.limit {
        [book]
      }
    end
    describe "book belongs to me" do
      # now our viewmodel needs to get the current user
      describe "book is at home" do
        it "returns shelf name" do
          user = "a user"
          stub(book).on_loan? { false }
          stub(book).owned_by? { false }
          stub(book).owned_by?(user) { true }
          r = BookSearch.new(:start=>0, :end=>5, :class=>MyBook,
                             :user=>user)
          row = r.results.first
          assert_equal 'my shelf', row[:location]
        end
      end
    end
  end
end
