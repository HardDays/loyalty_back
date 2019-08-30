class RenameUserIdToCreatorId < ActiveRecord::Migration[5.2]
  def change
    rename_column :companies, :user_id, :creator_id
  end
end
