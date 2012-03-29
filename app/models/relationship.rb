class Relationship < ActiveRecord::Base
  attr_accessible :followed,:follower
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  default_scope  where(:removed_at=>nil, :blocked_at=>nil)

  def block
    self.blocked_at=Time.now
    save
  end
  def unfollow
    self.removed_at=Time.now
    save
  end
end
