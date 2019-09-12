class RenameSmsNotif < ActiveRecord::Migration[5.2]
  def change
    rename_column :sms_notifications, :user_id, :client_id
    rename_table :sms_notifications, :client_sms
  end
end
