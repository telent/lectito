class RemoveCreatedAtFromCollectionMembers < ActiveRecord::Migration
  def up
    remove_column :collection_members, :created_at
      end

  def down
    add_column :collection_members, :created_at, :string
  end
end
