class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :client_id
      t.integer :operator_id
      t.integer :store_id
      t.integer :loyalty_program_id
      t.integer :price
      t.boolean :use_points

      t.timestamps
    end
  end
end
