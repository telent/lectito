class RemoveOwnerFromBook < ActiveRecord::Migration
  def up
    remove_column :books, :owner_id
      end

  def down
    add_column :books, :owner_id, :integer
  end
end
