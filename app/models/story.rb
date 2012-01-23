class Story < ActiveRecord::Base
  belongs_to :user
  def image
    nil
  end
end
