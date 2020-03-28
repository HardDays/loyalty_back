class AddPromotionIdToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :promotion_id, :integer
  end
end
