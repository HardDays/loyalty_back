class AddWriteOffPointsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :write_off_points, :integer
  end
end
