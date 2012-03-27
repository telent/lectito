# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120319225653) do

  create_table "authorizations", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "authorizations", ["user_id"], :name => "index_authorizations_on_user_id"

  create_table "books", :force => true do |t|
    t.integer  "borrower_id"
    t.string   "references"
    t.integer  "current_shelf_id"
    t.integer  "edition_id"
    t.string   "notes"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "home_shelf_id"
    t.integer  "collection_id"
  end

  add_index "books", ["borrower_id"], :name => "index_books_on_borrower_id"
  add_index "books", ["current_shelf_id"], :name => "index_books_on_current_shelf_id"
  add_index "books", ["edition_id"], :name => "index_books_on_edition_id"

  create_table "collections", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "collections", ["user_id"], :name => "index_collections_on_user_id"

  create_table "editions", :force => true do |t|
    t.string   "title"
    t.string   "author"
    t.string   "publisher"
    t.string   "isbn"
    t.string   "cover_image"
    t.datetime "published"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "actor_id"
    t.string   "action"
    t.integer  "book_id"
    t.integer  "recipient_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "followlinks", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "followlinks", ["followed_id"], :name => "index_followlinks_on_followed_id"
  add_index "followlinks", ["follower_id"], :name => "index_followlinks_on_follower_id"

  create_table "shelves", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "shelves", ["user_id"], :name => "index_shelves_on_user_id"

  create_table "stories", :force => true do |t|
    t.string   "title"
    t.string   "story"
    t.integer  "user_id"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "stories", ["user_id"], :name => "index_stories_on_user_id"

  create_table "tags", :force => true do |t|
    t.integer  "user_id"
    t.integer  "edition_id"
    t.integer  "book_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tags", ["book_id"], :name => "index_tags_on_book_id"
  add_index "tags", ["edition_id"], :name => "index_tags_on_edition_id"
  add_index "tags", ["user_id"], :name => "index_tags_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "nickname"
    t.string   "fullname"
    t.string   "avatar"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
