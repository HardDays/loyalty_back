class AddInitialPointsToClientPoints < ActiveRecord::Migration[5.2]
  def change
    add_column :client_points, :initial_points, :integer
  end
end
