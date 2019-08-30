class AddLoyaltyProgramIdToLoyaltyLevel < ActiveRecord::Migration[5.2]
  def change
    add_column :loyalty_levels, :loyalty_progam_id, :integer
  end
end
