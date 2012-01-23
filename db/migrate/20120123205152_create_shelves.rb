class CreateShelves < ActiveRecord::Migration
  def change
    create_table :shelves do |t|
      t.references :user
      t.string :name

      t.timestamps
    end
    add_index :shelves, :user_id
  end
end
