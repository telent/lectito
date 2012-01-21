require 'test_helper'

describe Edition do
  it "has title, author, publisher attributes" do
    @e=Edition.create
    [:title,:author,:publisher].each do |att|
      assert @e.respond_to? att
    end
  end
end
