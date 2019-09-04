class ChangeClientPointLoyalty < ActiveRecord::Migration[5.2]
  def change
    remove_column :client_points, :loyalty_program_id
    add_column :client_points, :loyalty_level_id, :integer
  end
end
