class AddPublicToCollection < ActiveRecord::Migration
  def change
    add_column :collections,:public,:boolean
    add_column :collections,:private,:boolean
  end
end
