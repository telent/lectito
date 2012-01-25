require "test_helper"

describe Book do
  before do
    @published=nil
    @esubscriber=Event.subscribe proc {|e| 
      @published=Hash[[:action,:actor,:book,:recipient].map{|m| [m,e.send(m)]}]
    }
    @user=User.create(:nickname=>"dan")
    @author='Philip K. Dick'
    @title='Time Out Of Joint'
    @isbn='9780140171730'
    @publisher='RoC'
    @shelf=Shelf.create(:user=>@user,:name=>"A SHELF")
    @collection=Collection.create(:user=>@user,:name=>"my books")
    @edition=Edition.create(:title=>@title,:author=>@author,
                            :isbn=>@isbn,:publisher=>@publisher)
  end
  after do
    Event.unsubscribe @esubscriber
  end
  
  describe "#lend" do
    before do
      @borrower=User.new(:id=>-11,:nickname=>"borrower")
      @book=Book.create(:edition=>@edition,
                        :home_shelf=>@shelf,
                        :collection=>@collection)
    end
    
    it "can be lent if on shelf" do
      @book.lend(@borrower)
      assert_equal @borrower, @book.borrower
      @book.current_shelf.must_be_nil
      assert @book.on_loan?

      assert_equal :lend,@published[:action]
      assert_equal @book,@published[:book]
      assert_equal @user,@published[:actor]
      assert_equal @borrower,@published[:recipient]
    end
    
    it "can be returned if lent" do
      @book.lend(@borrower)
      @book.return
      refute @book.on_loan?
      assert_equal :return,@published[:action]
      assert_equal @book,@published[:book]
      assert_equal @borrower,@published[:actor]
    end
    
    it "can't be lent to its owner" do
      assert_raises(Exception) {
        @book.lend(@book.owner)
      }
      refute @book.on_loan?
    end
    
    it "cannot be lent if already on loan" do  
      @thief=User.new(:id=>-12,:nickname=>"borrower 3")
      @book.lend(@borrower)
      assert @book.on_loan?
      assert_raises(Exception) {
        @book.lend(@thief)
      }
      assert_equal @borrower, @book.borrower
    end
  end
end
       
