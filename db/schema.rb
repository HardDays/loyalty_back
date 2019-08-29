# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_29_101011) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "call_backs", force: :cascade do |t|
    t.integer "company_id"
    t.string "phone"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.string "password_confirm"
    t.string "phone"
    t.string "firstname"
    t.string "secondname"
    t.string "lastname"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "legal_entity"
    t.string "postcode"
    t.string "inn"
    t.string "bic"
    t.integer "bank"
    t.string "invoice"
    t.string "kpp"
    t.string "checking_account"
    t.string "phone"
    t.string "web_site"
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "creator_confirmations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "confirm_status"
    t.string "confirm_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "creators", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.string "password_confirm"
    t.integer "company_id"
    t.string "firstname"
    t.string "secondname"
    t.string "lastname"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "operators", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.string "password_confirm"
    t.integer "store_id"
    t.string "firstname"
    t.string "secondname"
    t.string "lastname"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.integer "company_id"
    t.string "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_type"
  end

end
