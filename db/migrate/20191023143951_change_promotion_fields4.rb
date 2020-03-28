class ChangePromotionFields4 < ActiveRecord::Migration[5.2]
  def change
    rename_column :promotions, :accural_on_points, :accrual_on_points

  end
end
