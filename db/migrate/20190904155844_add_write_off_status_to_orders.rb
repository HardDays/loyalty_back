class AddWriteOffStatusToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :write_off_status, :integer
  end
end
