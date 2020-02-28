class CreateTelegramGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :telegram_groups do |t|
      t.integer :company_id
      t.string :group_id

      t.timestamps
    end
  end
end
