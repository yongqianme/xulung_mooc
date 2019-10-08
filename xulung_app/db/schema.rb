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

ActiveRecord::Schema.define(version: 20160423130007) do

  create_table "betausers", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "betausers", ["email"], name: "index_betausers_on_email", unique: true

  create_table "comments", force: true do |t|
    t.integer  "post_id"
    t.text     "body"
    t.string   "author"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "consultants", force: true do |t|
    t.integer  "user_id"
    t.string   "realname"
    t.string   "tel"
    t.string   "email"
    t.string   "alipay"
    t.string   "dashang"
    t.string   "company"
    t.string   "position"
    t.string   "workyear"
    t.integer  "hourrate"
    t.text     "experience"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar"
  end

  add_index "consultants", ["user_id"], name: "index_consultants_on_user_id"

  create_table "favorites", force: true do |t|
    t.integer  "user_id"
    t.integer  "favorited_id"
    t.string   "favorited_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["favorited_id", "favorited_type"], name: "index_favorites_on_favorited_id_and_favorited_type"
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id"

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "invites", force: true do |t|
    t.string   "email"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.string   "subject"
    t.string   "out_trade_no"
    t.float    "total_fee"
    t.integer  "membership_id"
    t.string   "trade_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "pages", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "author"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "published",  default: true
    t.integer  "hit",        default: 1677
    t.string   "slug"
  end

  add_index "pages", ["slug"], name: "index_pages_on_slug"
  add_index "pages", ["user_id"], name: "index_pages_on_user_id"

  create_table "photos", force: true do |t|
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "photos", ["user_id"], name: "index_photos_on_user_id"

# Could not dump table "posts" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id"
  end

  add_index "taggings", ["post_id"], name: "index_taggings_on_post_id"

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
    t.string   "username"
    t.boolean  "provider",               default: false
    t.string   "locale"
    t.integer  "membership",             default: 0
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.boolean  "terms_of_service",       default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count"
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

  create_table "videos", force: true do |t|
    t.string   "filename"
    t.integer  "filesize"
    t.string   "permalink"
    t.text     "description"
    t.string   "still"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",     default: true
    t.integer  "user_id"
    t.integer  "hit",           default: 0
    t.text     "visitor_ids"
    t.integer  "courselist_id"
    t.integer  "membergroup",   default: 0
    t.boolean  "approved",      default: false
    t.string   "slug"
  end

  add_index "videos", ["approved"], name: "index_videos_on_approved"
  add_index "videos", ["courselist_id"], name: "index_videos_on_courselist_id"
  add_index "videos", ["slug"], name: "index_videos_on_slug"
  add_index "videos", ["user_id"], name: "index_videos_on_user_id"

  create_table "votes", force: true do |t|
    t.integer  "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
