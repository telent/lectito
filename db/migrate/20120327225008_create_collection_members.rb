class CreateCollectionMembers < ActiveRecord::Migration
  def change
    create_table :collection_members do |t|
      t.references :owner
      t.references :member

      t.timestamps
    end
    add_index :collection_members, :owner_id
    add_index :collection_members, :member_id
  end
end
