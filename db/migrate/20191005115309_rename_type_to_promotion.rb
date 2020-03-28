class RenameTypeToPromotion < ActiveRecord::Migration[5.2]
  def change
    rename_column :loyalty_levels, :type, :promotion
  end
end
