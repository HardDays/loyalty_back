class CreateVkEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :vk_events do |t|
      t.integer :vk_group_id
      t.integer :client_id
      t.integer :event_type

      t.timestamps
    end
  end
end
