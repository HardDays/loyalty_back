class AddSmsStatusToSmsNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :sms_notifications, :sms_status, :integer
  end
end
