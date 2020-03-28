class RenamePoints < ActiveRecord::Migration[5.2]
  def change
    rename_column :client_points, :points, :current_points
  end
end
