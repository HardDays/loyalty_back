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

ActiveRecord::Schema.define(version: 2020_03_19_082118) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "call_backs", force: :cascade do |t|
    t.integer "company_id"
    t.string "phone"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cards", force: :cascade do |t|
    t.string "number"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "operator_id"
    t.integer "company_id"
  end

  create_table "client_points", force: :cascade do |t|
    t.integer "order_id"
    t.integer "current_points"
    t.integer "client_id"
    t.date "activation_date"
    t.date "burning_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "loyalty_level_id"
    t.integer "initial_points"
    t.integer "points_source"
    t.integer "promotion_id"
    t.integer "loyalty_program_id"
    t.integer "operator_id"
    t.integer "vk_event_id"
  end

  create_table "client_sms", force: :cascade do |t|
    t.integer "client_id"
    t.integer "sms_type"
    t.integer "client_point_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "send_at"
    t.integer "sms_status"
  end

  create_table "clients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.integer "user_id"
    t.integer "loyalty_program_id"
    t.string "card_number"
    t.integer "recommendator_id"
    t.integer "operator_id"
    t.string "vk_id"
    t.string "telegram_username"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.integer "creator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "tariff_plan_purchase_id"
  end

  create_table "creators", force: :cascade do |t|
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
    t.integer "write_off_rule_percent"
    t.integer "write_off_rule_points"
    t.integer "accordance_rule"
    t.integer "accordance_points"
    t.integer "accordance_percent"
    t.boolean "accrual_on_points"
    t.boolean "accrual_on_birthday"
    t.integer "birthday_points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "loyalty_program_id"
    t.integer "write_off_points"
    t.integer "write_off_money"
    t.integer "promotion"
    t.string "name"
  end

  create_table "loyalty_programs", force: :cascade do |t|
    t.integer "company_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sum_type"
    t.integer "rounding_rule"
    t.integer "register_points"
    t.integer "first_buy_points"
    t.integer "write_off_min_price"
    t.integer "recommend_recommendator_points"
    t.integer "recommend_registered_points"
    t.integer "sms_burning_days"
    t.boolean "accrual_on_register"
    t.boolean "accrual_on_first_buy"
    t.boolean "write_off_limited"
    t.boolean "sms_on_register"
    t.boolean "sms_on_points"
    t.boolean "sms_on_write_off"
    t.boolean "sms_on_burning"
    t.boolean "sms_on_birthday"
    t.boolean "accrual_on_recommend"
  end

  create_table "operators", force: :cascade do |t|
    t.integer "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.integer "user_id"
    t.integer "operator_status"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "client_id"
    t.integer "operator_id"
    t.integer "store_id"
    t.integer "loyalty_program_id"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "write_off_status"
    t.integer "write_off_points"
    t.integer "promotion_id"
  end

  create_table "password_resets", force: :cascade do |t|
    t.integer "user_id"
    t.string "code"
    t.integer "confirm_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "promotions", force: :cascade do |t|
    t.string "name"
    t.datetime "begin_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.integer "accrual_rule"
    t.integer "accrual_percent"
    t.integer "accrual_points"
    t.integer "accrual_money"
    t.integer "burning_rule"
    t.integer "burning_days"
    t.integer "activation_rule"
    t.integer "activation_days"
    t.integer "write_off_rule"
    t.integer "write_off_rule_percent"
    t.integer "write_off_rule_points"
    t.integer "accordance_rule"
    t.integer "accordance_points"
    t.integer "accordance_percent"
    t.boolean "accrual_on_points"
    t.boolean "write_off_limited"
    t.integer "write_off_min_price"
    t.integer "rounding_rule"
  end

  create_table "service_tokens", force: :cascade do |t|
    t.integer "company_id"
    t.string "one_s"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "tariff_plan_purchases", force: :cascade do |t|
    t.integer "tariff_plan_id"
    t.date "expired_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tariff_plans", force: :cascade do |t|
    t.integer "price"
    t.integer "days"
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tariff_type"
  end

  create_table "telegram_events", force: :cascade do |t|
    t.integer "event_type"
    t.integer "client_id"
    t.integer "telegram_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "telegram_groups", force: :cascade do |t|
    t.integer "company_id"
    t.string "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bot_code"
    t.integer "join_points"
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
    t.integer "gender"
    t.date "birth_day"
  end

  create_table "vk_events", force: :cascade do |t|
    t.integer "vk_group_id"
    t.integer "client_id"
    t.integer "event_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "post_id"
  end

  create_table "vk_groups", force: :cascade do |t|
    t.integer "company_id"
    t.string "confirmation_code"
    t.boolean "confirmed"
    t.string "callback_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "group_id"
    t.integer "group_join_points"
    t.integer "wall_repost_points"
    t.integer "wall_like_points"
    t.integer "wall_reply_points"
  end

end
