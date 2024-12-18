# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_12_12_131837) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "attr_colors", force: :cascade do |t|
    t.string "rgb"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attr_tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cart_items", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "good_id", null: false
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["good_id"], name: "index_cart_items_on_good_id"
    t.index ["user_id"], name: "index_cart_items_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "good_id", null: false
    t.string "content"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["good_id"], name: "index_comments_on_good_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "favorite_items", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "good_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["good_id"], name: "index_favorite_items_on_good_id"
    t.index ["user_id"], name: "index_favorite_items_on_user_id"
  end

  create_table "good_color_relations", force: :cascade do |t|
    t.integer "good_id", null: false
    t.integer "attr_color_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attr_color_id"], name: "index_good_color_relations_on_attr_color_id"
    t.index ["good_id"], name: "index_good_color_relations_on_good_id"
  end

  create_table "good_tag_relations", force: :cascade do |t|
    t.integer "good_id", null: false
    t.integer "attr_tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attr_tag_id"], name: "index_good_tag_relations_on_attr_tag_id"
    t.index ["good_id"], name: "index_good_tag_relations_on_good_id"
  end

  create_table "goods", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.decimal "price", precision: 8, scale: 2
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goods_images", id: false, force: :cascade do |t|
    t.integer "good_id", null: false
    t.integer "image_id", null: false
    t.index ["good_id"], name: "index_goods_images_on_good_id"
    t.index ["image_id"], name: "index_goods_images_on_image_id"
  end

  create_table "images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "title"
    t.index ["user_id"], name: "index_images_on_user_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "good_id", null: false
    t.integer "count"
    t.integer "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["good_id"], name: "index_order_items_on_good_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.string "address"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "user_role_relations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "user_role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_role_relations_on_user_id"
    t.index ["user_role_id"], name: "index_user_role_relations_on_user_role_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password"
    t.string "email"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cart_items", "goods"
  add_foreign_key "cart_items", "users"
  add_foreign_key "comments", "goods"
  add_foreign_key "comments", "users"
  add_foreign_key "favorite_items", "goods"
  add_foreign_key "favorite_items", "users"
  add_foreign_key "good_color_relations", "attr_colors"
  add_foreign_key "good_color_relations", "goods"
  add_foreign_key "good_tag_relations", "attr_tags"
  add_foreign_key "good_tag_relations", "goods"
  add_foreign_key "images", "users"
  add_foreign_key "order_items", "goods"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "users"
  add_foreign_key "user_role_relations", "user_roles"
  add_foreign_key "user_role_relations", "users"
end
