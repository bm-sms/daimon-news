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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151130074339) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "daimon_news_admin_posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "daimon_news_admin_site_id", null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "daimon_news_admin_posts", ["daimon_news_admin_site_id"], name: "index_daimon_news_admin_posts_on_daimon_news_admin_site_id", using: :btree

  create_table "daimon_news_admin_sites", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "site_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "posts", ["site_id"], name: "index_posts_on_site_id", using: :btree

  create_table "sites", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "daimon_news_admin_posts", "daimon_news_admin_sites", on_delete: :cascade
  add_foreign_key "posts", "sites", on_delete: :cascade
end
