class AddGroupdIdToVkSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :vk_settings, :group_id, :string
  end
end
