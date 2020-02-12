class AddVkIdToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :vk_id, :string
  end
end
