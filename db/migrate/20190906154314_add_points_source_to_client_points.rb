class AddPointsSourceToClientPoints < ActiveRecord::Migration[5.2]
  def change
    add_column :client_points, :points_source, :integer
  end
end
