class RemoveCreatedAtFromFollowlink < ActiveRecord::Migration
  def up
    remove_column :followlinks, :created_at
      end

  def down
    add_column :followlinks, :created_at, :string
  end
end
