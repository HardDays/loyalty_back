class AddLoyaltyProgramIdToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :loyalty_program_id, :integer
  end
end
