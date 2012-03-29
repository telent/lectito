class AddRemovedAtToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :removed_at, :datetime

  end
end
