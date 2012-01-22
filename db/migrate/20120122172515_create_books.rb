class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.references :owner
      t.references :borrower
      t.string :home_shelf
      t.string :references
      t.references :current_shelf
      t.references :edition
      t.string :notes

      t.timestamps
    end
    add_index :books, :owner_id
    add_index :books, :borrower_id
    add_index :books, :current_shelf_id
    add_index :books, :edition_id
  end
end
