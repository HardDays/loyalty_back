class AddOperatorIdToClientPoints < ActiveRecord::Migration[5.2]
  def change
    add_column :client_points, :operator_id, :integer
  end
end
