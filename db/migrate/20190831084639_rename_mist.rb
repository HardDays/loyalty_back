class RenameMist < ActiveRecord::Migration[5.2]
  def change
    rename_column :loyalty_levels, :min_pirce, :min_price
  end
end
