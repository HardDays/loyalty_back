class ChangeLoyaltyLevel2 < ActiveRecord::Migration[5.2]
  def change
    add_column :loyalty_levels, :write_off_limited, :boolean
    add_column :loyalty_levels, :write_off_min_price, :integer
    add_column :loyalty_levels, :accrual_on_recommend, :boolean
    add_column :loyalty_levels, :recommend_recommendator_points, :integer
    add_column :loyalty_levels, :recommend_registered_points, :integer
  end
end
