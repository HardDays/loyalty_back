class RenameHashToSome < ActiveRecord::Migration[5.2]
  def change
    rename_column :user_confirmations, :hash, :confirm_hash
  end
end
