class CreateSmsNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :sms_notifications do |t|
      t.integer :user_id
      t.integer :sms_type
      t.integer :client_points_id

      t.timestamps
    end
  end
end
