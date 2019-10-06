class AddColumncToLoyaltyLevel < ActiveRecord::Migration[5.2]
  def change
    add_column :loyalty_levels, :type, :integer
  end
end
