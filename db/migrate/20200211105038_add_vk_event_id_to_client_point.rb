class AddVkEventIdToClientPoint < ActiveRecord::Migration[5.2]
  def change
    add_column :client_points, :vk_event_id, :integer
  end
end
