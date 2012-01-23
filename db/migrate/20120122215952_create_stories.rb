class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :title
      t.string :story
      t.references :user
      t.string :url

      t.timestamps
    end
    add_index :stories, :user_id
  end
end
