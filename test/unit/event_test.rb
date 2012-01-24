require 'test_helper'

describe Event do
  it "must have recognised action" do
    e=Event.new(:action=>"Lend")
    assert e.valid?, "Lend"
    e=Event.new(:action=>"Blend")
    refute e.valid?, "Blend"
  end
  it "calls registered subscribers when an event is pushed" do
    succeeded=false
    Event.subscribe proc { succeeded=true }
    Event.publish(action: :join, actor: User.create(nickname: "hellO" ))
    assert succeeded
  end
end
