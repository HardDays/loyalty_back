class ChangePromotionFields2 < ActiveRecord::Migration[5.2]
  def change
    add_column :promotions, :rounding_rule, :integer
  end
end
