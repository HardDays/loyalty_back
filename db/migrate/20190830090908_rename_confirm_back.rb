class RenameConfirmBack < ActiveRecord::Migration[5.2]
  def change
    rename_table :creator_confirmations, :user_confirmations
    add_column :user_confirmations, :code, :string
  end
end
