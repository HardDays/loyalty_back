class CreateLoyaltyLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :loyalty_levels do |t|
      t.integer :level_type
      t.integer :min_pirce
      t.date :begin_date
      t.date :end_date
      t.integer :accrual_rule
      t.integer :accrual_percent
      t.integer :accrual_points
      t.integer :accrual_money
      t.integer :burning_rule
      t.integer :burning_days
      t.integer :activation_rule
      t.integer :activation_days
      t.integer :write_off_rule
      t.integer :write_off_percent
      t.integer :write_off_points
      t.integer :accordance_rule
      t.integer :accordance_points
      t.integer :accordance_percent
      t.boolean :accural_on_points
      t.boolean :accural_on_register
      t.integer :register_points
      t.boolean :accural_on_first_buy
      t.integer :first_buy_points
      t.boolean :accural_on_birthday
      t.integer :birthday_points
      t.integer :rounding_rule
      t.boolean :sms_on_register
      t.boolean :sms_on_points
      t.boolean :sms_on_write_off
      t.boolean :sms_on_burning
      t.integer :sms_burning_days

      t.timestamps
    end
  end
end
