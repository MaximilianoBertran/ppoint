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

ActiveRecord::Schema[7.0].define(version: 2022_09_06_150905) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "categories_products", id: false, force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_categories_products_on_category_id"
    t.index ["product_id"], name: "index_categories_products_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "brand"
    t.integer "units"
    t.string "vendor"
    t.integer "price"
    t.jsonb "extra"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index "((extra ->> 'color'::text))", name: "index_products_on_extra_color"
    t.index "((extra ->> 'description'::text))", name: "index_products_on_extra_description"
    t.index "((extra ->> 'height'::text))", name: "index_products_on_extra_height"
    t.index "((extra ->> 'length'::text))", name: "index_products_on_extra_length"
    t.index "((extra ->> 'material'::text))", name: "index_products_on_extra_material"
    t.index "((extra ->> 'weight'::text))", name: "index_products_on_extra_weight"
    t.index "((extra ->> 'width'::text))", name: "index_products_on_extra_width"
    t.index ["created_at"], name: "index_products_on_created_at"
    t.index ["extra"], name: "index_products_on_extra"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer "units"
    t.integer "amount"
    t.bigint "user_id"
    t.bigint "product_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["product_id"], name: "index_purchases_on_product_id"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "unique_emails", unique: true
  end

  create_table "users_token", force: :cascade do |t|
    t.bigint "user_id"
    t.string "token"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_users_token_on_user_id"
  end

  add_foreign_key "purchases", "products"
end
