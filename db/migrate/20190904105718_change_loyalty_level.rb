class ChangeLoyaltyLevel < ActiveRecord::Migration[5.2]
  def change
    rename_column :loyalty_levels, :write_off_points, :write_off_rule_points
    rename_column :loyalty_levels, :write_off_percent, :write_off_rule_percent
    add_column :loyalty_levels, :write_off_points, :integer
    add_column :loyalty_levels, :write_off_money, :integer

  end
end
