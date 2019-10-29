class AddOperatorStatusToOperator < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :operator_status, :integer
  end
end
