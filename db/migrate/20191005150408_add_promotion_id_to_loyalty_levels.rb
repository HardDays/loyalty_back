class AddPromotionIdToLoyaltyLevels < ActiveRecord::Migration[5.2]
  def change
    add_column :loyalty_levels, :promotion_id, :integer
  end
end
