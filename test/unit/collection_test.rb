require 'test_helper'

describe Collection do
  it "public collection is visible to all" do
    u=User.create
    c=Collection.create user: u, public: true
    assert c.visible_for?(u)
    assert c.visible_for?(User.create)    
  end
  it "private collection is visible only to owner" do
    u=User.create
    c=Collection.create user: u, private: true, name: 'my collection'
    assert c.visible_for?(u)
    refute c.visible_for?(User.create) 
  end
  it "otherwise can have named users" do
    u=User.create
    c=Collection.create user: u, name: 'my collection'
    u2=User.create
    c.add_member u2
    
    assert c.visible_for?(u)
    assert c.visible_for?(u2)
    refute c.visible_for?(User.create) 
  end
  it "private collection refuses to add named users" do
    u=User.create
    c=Collection.create user: u, private: true
    assert_raises StandardError do
      u2=User.create
      c.add_member u2
    end
  end
end

