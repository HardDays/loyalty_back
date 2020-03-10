class AddJoinPointsToTelegramGroup < ActiveRecord::Migration[5.2]
  def change
    add_column :telegram_groups, :join_points, :integer
  end
end
