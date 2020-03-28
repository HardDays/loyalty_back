class AddTelegramUsernameToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :telegram_username, :string
  end
end
