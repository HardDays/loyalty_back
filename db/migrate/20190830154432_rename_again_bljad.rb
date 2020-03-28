class RenameAgainBljad < ActiveRecord::Migration[5.2]
  def change
    rename_column :loyalty_levels, :accural_rule, :accrual_rule
    rename_column :loyalty_levels, :accural_percent, :accrual_percent
    rename_column :loyalty_levels, :accural_points, :accrual_points
    rename_column :loyalty_levels, :accural_money, :accrual_money

    rename_column :loyalty_levels, :accural_on_points, :accrual_on_points
    rename_column :loyalty_levels, :accural_on_register, :accrual_on_register
    rename_column :loyalty_levels, :accural_on_first_buy, :accrual_on_first_buy
    rename_column :loyalty_levels, :accural_on_birthday, :accrual_on_birthday

  end
end
