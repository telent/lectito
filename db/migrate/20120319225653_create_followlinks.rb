class CreateFollowlinks < ActiveRecord::Migration
  def change
    create_table :followlinks do |t|
      t.references :follower
      t.references :followed

      t.timestamps
    end
    add_index :followlinks, :follower_id
    add_index :followlinks, :followed_id
  end
end
