class RenameInSms < ActiveRecord::Migration[5.2]
  def change
    rename_column :sms_notifications, :user_id, :client_id
  end
end
