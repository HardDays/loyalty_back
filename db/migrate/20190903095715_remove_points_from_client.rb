class RemovePointsFromClient < ActiveRecord::Migration[5.2]
  def change
    remove_column :clients, :points
  end
end
