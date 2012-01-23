class AddHomeshelfToBooks < ActiveRecord::Migration
  def change
    remove_column :books, :home_shelf
    add_column :books, :home_shelf_id ,:integer
  end
end
