class AddPromotionIdToClientPoints < ActiveRecord::Migration[5.2]
  def change
    add_column :client_points, :promotion_id, :integer
    remove_column :loyalty_levels, :promotion_id, :integer
  end
end
