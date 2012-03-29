class AddBlockedAtToRelationship < ActiveRecord::Migration
  def change
    add_column :relationships, :blocked_at, :datetime

  end
end
