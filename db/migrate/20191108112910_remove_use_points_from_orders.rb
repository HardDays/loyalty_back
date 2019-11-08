class RemoveUsePointsFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :use_points, :boolean
  end
end
