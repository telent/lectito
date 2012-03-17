class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.references :user
      t.references :edition
      t.references :book
      t.string :name

      t.timestamps
    end
    add_index :tags, :user_id
    add_index :tags, :edition_id
    add_index :tags, :book_id
  end
end
