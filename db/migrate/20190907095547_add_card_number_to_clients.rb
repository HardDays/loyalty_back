class AddCardNumberToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :card_number, :string
  end
end
