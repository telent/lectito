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

  it 'is unshelved if home shelf is unset' do
    b=Book.create(:edition=>@edition, :collection=>@collection)
    assert b.valid?
  end
  it 'requires a collection' do
    refute Book.create(:edition=>@edition, :home_shelf=>@shelf).valid?
  end
  
  describe "#lend" do
    before do
      @borrower=User.new(:id=>-11,:nickname=>"borrower")
      @book=Book.create(:edition=>@edition,
                        :home_shelf=>@shelf,
                        :collection=>@collection)
    end
    
    it "can be lent if on shelf" do
      refute @book.on_loan?
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

  describe "#give" do
    before do
      @recipient=User.new(:id=>-11,:nickname=>"lucky winner")
      @book=Book.create(:edition=>@edition,
                        :home_shelf=>@shelf,
                        :collection=>@collection)
    end
    
    it "can be given to another user" do
      @book.give(@recipient)
      @book.current_shelf.must_be_nil
      assert_equal @recipient, @book.owner
      # it appears in their private collection
      c=@book.collection
      assert_equal c,@recipient.private_collection
      refute @book.on_loan?
    end
  end


  describe 'tags' do
    it "#tag creates a tag with appropriate edition/user links" do
      @book=Book.create(:edition=>@edition,
                        :home_shelf=>@shelf,
                        :collection=>@collection)
      tag=@book.tag 'fiction'
      assert_equal @edition,tag.edition
      assert_equal @user,tag.user
      assert_equal @book,tag.book
      assert_equal 'fiction',tag.name
    end
    it "#tag_names returns a list of tag names" do
      @book=Book.create(:edition=>@edition,
                        :home_shelf=>@shelf,
                        :collection=>@collection)
      test_tags=%w(fiction sf 2011 hello)
      test_tags.each do|tg|
        @book.tag tg
      end
      assert_equal test_tags.sort, @book.tag_names.sort
    end
  end
end
       
