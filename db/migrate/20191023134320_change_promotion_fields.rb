class ChangePromotionFields < ActiveRecord::Migration[5.2]
  def change
    add_column :promotions, :accrual_rule, :integer
    add_column :promotions, :accrual_percent, :integer
    add_column :promotions, :accrual_points, :integer
    add_column :promotions, :accrual_money, :integer
    add_column :promotions, :burning_rule, :integer
    add_column :promotions, :burning_days, :integer
    add_column :promotions, :activation_rule, :integer
    add_column :promotions, :activation_days, :integer
    add_column :promotions, :write_off_rule, :integer
    add_column :promotions, :write_off_percent, :integer
    add_column :promotions, :write_off_points, :integer
    add_column :promotions, :accordance_rule, :integer
    add_column :promotions, :accordance_points, :integer
    add_column :promotions, :accordance_percent, :integer
    add_column :promotions, :accural_on_points, :boolean
    add_column :promotions, :write_off_limited, :boolean
    add_column :promotions, :write_off_min_price, :integer

  end
end
