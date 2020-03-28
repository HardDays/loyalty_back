class AddFieldsToVkGroup < ActiveRecord::Migration[5.2]
  def change
    add_column :vk_groups, :group_join_points, :integer
    add_column :vk_groups, :wall_repost_points, :integer
    add_column :vk_groups, :wall_like_points, :integer
    add_column :vk_groups, :wall_reply_points, :integer

  end
end
