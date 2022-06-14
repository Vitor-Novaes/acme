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

ActiveRecord::Schema[7.0].define(version: 2022_06_14_181838) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_clients_on_email", unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.string "code"
    t.datetime "payment_date"
    t.string "status", default: "WAITING", null: false
    t.string "state", null: false
    t.string "address", null: false
    t.string "city", null: false
    t.decimal "net_value", precision: 8, scale: 2, null: false
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_orders_on_client_id"
    t.index ["code"], name: "index_orders_on_code", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.decimal "base_value", precision: 8, scale: 2, null: false
    t.string "name"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "registers", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.bigint "variant_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_registers_on_order_id"
    t.index ["product_id"], name: "index_registers_on_product_id"
    t.index ["variant_id"], name: "index_registers_on_variant_id"
  end

  create_table "variants", force: :cascade do |t|
    t.string "code", null: false
    t.decimal "value", precision: 8, scale: 2, null: false
    t.string "image", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sales", default: 0
    t.index ["product_id"], name: "index_variants_on_product_id"
  end

  add_foreign_key "orders", "clients"
  add_foreign_key "products", "categories"
  add_foreign_key "registers", "orders"
  add_foreign_key "registers", "products"
  add_foreign_key "registers", "variants"
  add_foreign_key "variants", "products"
end
