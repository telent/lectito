require 'test_helper'

describe User do
  it "has nickname, fullname, avatar, email" do
    @u=User.create
    [:nickname, :fullname, :avatar, :email].each do |att|
      assert @u.respond_to? att
    end
  end
end
