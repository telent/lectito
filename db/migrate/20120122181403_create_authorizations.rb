class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.string :uid
      t.references :user

      t.timestamps
    end
    add_index :authorizations, :user_id
  end
end
