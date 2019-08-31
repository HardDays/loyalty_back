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

ActiveRecord::Schema.define(version: 2019_08_31_084639) do

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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.integer "user_id"
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
    t.integer "creator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "creators", force: :cascade do |t|
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "loyalty_levels", force: :cascade do |t|
    t.integer "level_type"
    t.integer "min_price"
    t.date "begin_date"
    t.date "end_date"
    t.integer "accrual_rule"
    t.integer "accrual_percent"
    t.integer "accrual_points"
    t.integer "accrual_money"
    t.integer "burning_rule"
    t.integer "burning_days"
    t.integer "activation_rule"
    t.integer "activation_days"
    t.integer "write_off_rule"
    t.integer "write_off_percent"
    t.integer "write_off_points"
    t.integer "accordance_rule"
    t.integer "accordance_points"
    t.integer "accordance_percent"
    t.boolean "accrual_on_points"
    t.boolean "accrual_on_register"
    t.integer "register_points"
    t.boolean "accrual_on_first_buy"
    t.integer "first_buy_points"
    t.boolean "accrual_on_birthday"
    t.integer "birthday_points"
    t.integer "rounding_rule"
    t.boolean "sms_on_register"
    t.boolean "sms_on_points"
    t.boolean "sms_on_write_off"
    t.boolean "sms_on_burning"
    t.integer "sms_burning_days"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "loyalty_program_id"
  end

  create_table "loyalty_programs", force: :cascade do |t|
    t.integer "company_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "operators", force: :cascade do |t|
    t.integer "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.integer "user_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country"
    t.string "city"
    t.string "street"
    t.string "house"
  end

  create_table "user_confirmations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "confirm_status"
    t.string "confirm_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_type"
    t.string "first_name"
    t.string "second_name"
    t.string "last_name"
    t.string "phone"
  end

end
