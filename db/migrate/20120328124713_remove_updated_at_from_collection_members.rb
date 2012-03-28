class RemoveUpdatedAtFromCollectionMembers < ActiveRecord::Migration
  def up
    remove_column :collection_members, :updated_at
      end

  def down
    add_column :collection_members, :updated_at, :string
  end
end
