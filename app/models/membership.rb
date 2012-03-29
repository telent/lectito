class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :collection
  default_scope  where(:removed_at=>nil)

  def remove
    self.removed_at=Time.now
    self.save
  end
end
