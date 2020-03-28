class CreateTelegramEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :telegram_events do |t|
      t.integer :event_type
      t.integer :client_id
      t.integer :telegram_group_id

      t.timestamps
    end
  end
end
