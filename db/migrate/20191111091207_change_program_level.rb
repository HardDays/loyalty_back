class ChangeProgramLevel < ActiveRecord::Migration[5.2]
  def change
    add_column :loyalty_programs, :rounding_rule, :integer
    add_column :loyalty_programs, :register_points, :integer
    add_column :loyalty_programs, :first_buy_points, :integer
    add_column :loyalty_programs, :write_off_min_price, :integer
    add_column :loyalty_programs, :recommend_recommendator_points, :integer
    add_column :loyalty_programs, :recommend_registered_points, :integer
    add_column :loyalty_programs, :sms_burning_days, :integer
    add_column :loyalty_programs, :accrual_on_register, :boolean
    add_column :loyalty_programs, :accrual_on_first_buy, :boolean
    add_column :loyalty_programs, :write_off_limited, :boolean
    add_column :loyalty_programs, :sms_on_register, :boolean
    add_column :loyalty_programs, :sms_on_points, :boolean
    add_column :loyalty_programs, :sms_on_write_off, :boolean
    add_column :loyalty_programs, :sms_on_burning, :boolean
    add_column :loyalty_programs, :sms_on_birthday, :boolean

    remove_column :loyalty_levels, :rounding_rule, :integer
    remove_column :loyalty_levels, :register_points, :integer
    remove_column :loyalty_levels, :first_buy_points, :integer
    remove_column :loyalty_levels, :write_off_min_price, :integer
    remove_column :loyalty_levels, :recommend_recommendator_points, :integer
    remove_column :loyalty_levels, :recommend_registered_points, :integer
    remove_column :loyalty_levels, :sms_burning_days, :integer
    remove_column :loyalty_levels, :accrual_on_register, :boolean
    remove_column :loyalty_levels, :accrual_on_first_buy, :boolean
    remove_column :loyalty_levels, :write_off_limited, :boolean
    remove_column :loyalty_levels, :sms_on_register, :boolean
    remove_column :loyalty_levels, :sms_on_points, :boolean
    remove_column :loyalty_levels, :sms_on_write_off, :boolean
    remove_column :loyalty_levels, :sms_on_burning, :boolean
    remove_column :loyalty_levels, :sms_on_birthday, :boolean
  end
end
