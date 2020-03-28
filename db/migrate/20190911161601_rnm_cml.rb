class RnmCml < ActiveRecord::Migration[5.2]
  def change
    rename_column :password_resets, :status, :confirm_status
  end
end
