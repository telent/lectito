class Relationship < ActiveRecord::Base
  attr_accessible :followed,:follower
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  default_scope  where(:removed_at=>nil, :blocked_at=>nil)

  # you might think we could have done this with an after_create_hook,
  # but no: Relationships are used both for Follow and Block, and it would
  # be bad form to notify someone that she has a new follower if actually
  # she's just blocked him ...

  def self.follow(*args)
    r=self.create(*args)
    e=Event.publish action: :follow, actor: r.follower, recipient: r.followed
    warn e.inspect
    r
  end

  def block
    self.blocked_at=Time.now
    save
  end

  def unfollow
    self.removed_at=Time.now
    save
  end
  def unblock
    self.removed_at=Time.now
    save
  end
end
