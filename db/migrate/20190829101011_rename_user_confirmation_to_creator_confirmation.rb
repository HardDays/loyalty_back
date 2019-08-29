class RenameUserConfirmationToCreatorConfirmation < ActiveRecord::Migration[6.0]
  def change
    rename_table :user_confirmations, :creator_confirmations
  end
end
