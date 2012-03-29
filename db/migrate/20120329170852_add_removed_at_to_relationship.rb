class AddRemovedAtToRelationship < ActiveRecord::Migration
  def change
    add_column :relationships, :removed_at, :datetime

  end
end
