class AddCollectionToBook < ActiveRecord::Migration
  def change
    add_column :books, :collection_id, :integer
  end
end
