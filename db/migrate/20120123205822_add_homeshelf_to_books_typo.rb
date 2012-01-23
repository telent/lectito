class AddHomeshelfToBooksTypo < ActiveRecord::Migration
  def change
    remove_column :books, :home_shelf
  end
end
