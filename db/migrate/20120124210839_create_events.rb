class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :actor
      t.string :action
      t.references :book
      t.references :recipient

      t.timestamps
    end
  end
end
