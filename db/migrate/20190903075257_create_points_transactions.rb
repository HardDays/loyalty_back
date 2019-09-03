class CreatePointsTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :client_points do |t|
      t.integer :order_id
      t.integer :points
      t.integer :client_id
      t.date :activation_date
      t.date :burning_date
      t.timestamps
    end
  end
end
