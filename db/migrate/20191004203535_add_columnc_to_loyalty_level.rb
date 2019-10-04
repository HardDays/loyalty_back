class AddColumncToLoyaltyLevel < ActiveRecord::Migration[6.0]
  def change
    add_column :loyalty_levels, :type, :integer
  end
end
