class AddBotCodeToTelegramGroup < ActiveRecord::Migration[5.2]
  def change
    add_column :telegram_groups, :bot_code, :string
  end
end
