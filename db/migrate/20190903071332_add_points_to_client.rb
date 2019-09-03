class AddPointsToClient < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :points, :integer
  end
end
