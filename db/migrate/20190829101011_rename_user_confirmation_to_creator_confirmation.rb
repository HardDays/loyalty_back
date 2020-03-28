class RenameUserConfirmationToCreatorConfirmation < ActiveRecord::Migration[5.2]
  def change
    rename_table :user_confirmations, :creator_confirmations
  end
end
