require 'test_helper'

describe User do
  it "has nickname, fullname, avatar, email" do
    @u=User.create
    [:nickname, :fullname, :avatar, :email].each do |att|
      assert @u.respond_to? att
    end
  end
  it "can be blocked" do
    @u=User.create
    @u2=User.create
    refute @u.blocking?(@u2), "not blocked"
    @u.block(@u2)
    assert @u.blocking?(@u2), "blocked"
  end
end
