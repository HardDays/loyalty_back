class RenameTypeToPromotion < ActiveRecord::Migration[6.0]
  def change
    rename_column :loyalty_levels, :type, :promotion
  end
end
