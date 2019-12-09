class AddOperatorIdToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :operator_id, :integer
  end
end
