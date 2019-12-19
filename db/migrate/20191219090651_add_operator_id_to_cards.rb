class AddOperatorIdToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :operator_id, :integer
  end
end
