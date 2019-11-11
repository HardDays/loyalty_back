class AddLoyaltyProgramToClientPoints < ActiveRecord::Migration[5.2]
  def change
    add_column :client_points, :loyalty_program_id, :integer
  end
end
