class AddSumTypeToLoyaltyProgram < ActiveRecord::Migration[5.2]
  def change
    add_column :loyalty_programs, :sum_type, :integer
  end
end
