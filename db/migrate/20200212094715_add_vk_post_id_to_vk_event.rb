class AddVkPostIdToVkEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :vk_events, :post_id, :string
  end
end
