class RemoveIdFromFollowlink < ActiveRecord::Migration
  def up
    remove_column :followlinks, :id
      end

  def down
    add_column :followlinks, :id, :integer
  end
end
