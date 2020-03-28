class RenameLoyaltyAcc < ActiveRecord::Migration[5.2]
  def change
    rename_column :loyalty_levels, :accrual_rule, :accural_rule
    rename_column :loyalty_levels, :accrual_percent, :accural_percent
    rename_column :loyalty_levels, :accrual_points, :accural_points
    rename_column :loyalty_levels, :accrual_money, :accural_money
  end
end
