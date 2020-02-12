class RenameVkSetting < ActiveRecord::Migration[5.2]
  def change
    rename_table :vk_settings, :vk_groups
  end
end
