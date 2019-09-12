class AddSendAtToSmsNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :sms_notifications, :send_at, :date
  end
end
