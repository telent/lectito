class RemoveUpdatedAtFromFollowlink < ActiveRecord::Migration
  def up
    remove_column :followlinks, :updated_at
      end

  def down
    add_column :followlinks, :updated_at, :string
  end
end
