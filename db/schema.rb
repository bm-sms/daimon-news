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

ActiveRecord::Schema.define(version: 20160322055719) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "site_id"
    t.string   "slug",        null: false
    t.integer  "order",       null: false
  end

  add_index "categories", ["slug", "site_id"], name: "index_categories_on_slug_and_site_id", unique: true, using: :btree

  create_table "credit_roles", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "order",      null: false
    t.integer  "site_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "credit_roles", ["site_id", "order"], name: "index_credit_roles_on_site_id_and_order", unique: true, using: :btree
  add_index "credit_roles", ["site_id"], name: "index_credit_roles_on_site_id", using: :btree

  create_table "credits", force: :cascade do |t|
    t.integer  "post_id",        null: false
    t.integer  "participant_id", null: false
    t.integer  "credit_role_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "credits", ["credit_role_id"], name: "index_credits_on_credit_role_id", using: :btree
  add_index "credits", ["participant_id"], name: "index_credits_on_participant_id", using: :btree
  add_index "credits", ["post_id"], name: "index_credits_on_post_id", using: :btree

  create_table "fixed_pages", force: :cascade do |t|
    t.integer  "site_id",    null: false
    t.string   "title"
    t.text     "body"
    t.string   "slug",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "fixed_pages", ["site_id", "slug"], name: "index_fixed_pages_on_site_id_and_slug", unique: true, using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "image",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "site_id",    null: false
  end

  create_table "links", force: :cascade do |t|
    t.string   "text",       null: false
    t.string   "url",        null: false
    t.integer  "order",      null: false
    t.integer  "site_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "links", ["site_id"], name: "index_links_on_site_id", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "site_id",    null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "memberships", ["site_id", "user_id"], name: "index_memberships_on_site_id_and_user_id", unique: true, using: :btree

  create_table "participants", force: :cascade do |t|
    t.integer  "site_id",     null: false
    t.string   "name",        null: false
    t.text     "description"
    t.string   "photo"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "participants", ["name"], name: "index_participants_on_name", using: :btree
  add_index "participants", ["site_id"], name: "index_participants_on_site_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body",                null: false
    t.integer  "site_id",             null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.datetime "published_at"
    t.integer  "category_id",         null: false
    t.string   "source_url"
    t.string   "thumbnail",           null: false
    t.integer  "author_id"
    t.text     "original_source"
    t.datetime "original_updated_at"
    t.integer  "public_id",           null: false
    t.text     "original_html"
    t.text     "stripped_html"
    t.text     "replaced_html"
  end

  add_index "posts", ["published_at", "id"], name: "index_posts_on_published_at_and_id", using: :btree
  add_index "posts", ["site_id", "id"], name: "index_posts_on_site_id_and_id", unique: true, using: :btree
  add_index "posts", ["site_id", "public_id"], name: "index_posts_on_site_id_and_public_id", unique: true, using: :btree
  add_index "posts", ["site_id"], name: "index_posts_on_site_id", using: :btree
  add_index "posts", ["updated_at"], name: "index_posts_on_updated_at", using: :btree

  create_table "sites", force: :cascade do |t|
    t.string   "name",                                 null: false
    t.string   "js_url"
    t.string   "css_url"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "fqdn",                                 null: false
    t.string   "tagline"
    t.string   "logo_url"
    t.string   "favicon_url"
    t.string   "mobile_favicon_url"
    t.string   "gtm_id"
    t.string   "content_header_url"
    t.string   "promotion_url"
    t.string   "sns_share_caption"
    t.string   "twitter_account"
    t.string   "menu_url"
    t.string   "home_url"
    t.string   "ad_client"
    t.string   "ad_slot"
    t.string   "description"
    t.string   "footer_url"
    t.boolean  "opened",               default: false, null: false
    t.string   "logo_image"
    t.string   "favicon_image"
    t.string   "mobile_favicon_image"
    t.text     "promotion_tag"
    t.text     "head_tag"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "name"
    t.boolean  "admin",                  default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "credit_roles", "sites"
  add_foreign_key "credits", "credit_roles"
  add_foreign_key "credits", "participants"
  add_foreign_key "credits", "posts"
  add_foreign_key "fixed_pages", "sites"
  add_foreign_key "images", "sites"
  add_foreign_key "links", "sites"
  add_foreign_key "memberships", "sites"
  add_foreign_key "memberships", "users"
  add_foreign_key "participants", "sites"
  add_foreign_key "posts", "sites"
end
