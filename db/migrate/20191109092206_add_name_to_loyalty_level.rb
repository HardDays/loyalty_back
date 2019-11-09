class AddNameToLoyaltyLevel < ActiveRecord::Migration[5.2]
  def change
    add_column :loyalty_levels, :name, :string
  end
end
