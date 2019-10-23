class ChangePromotionFields3 < ActiveRecord::Migration[5.2]
  def change
    rename_column :promotions, :write_off_percent, :write_off_rule_percent
    rename_column :promotions, :write_off_points, :write_off_rule_points
  end
end
