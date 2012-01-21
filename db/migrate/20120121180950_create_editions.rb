class CreateEditions < ActiveRecord::Migration
  def change
    create_table :editions do |t|
      t.string :title
      t.string :author
      t.string :publisher
      t.string :isbn
      t.string :cover_image
      t.datetime :published

      t.timestamps
    end
  end
end
