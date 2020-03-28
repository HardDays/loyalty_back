class RenameInSms2 < ActiveRecord::Migration[5.2]
  def change
    rename_column :sms_notifications, :client_id, :user_id
  end
end
