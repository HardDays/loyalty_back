class CreateVkSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :vk_settings do |t|
      t.integer :company_id
      t.string :confirmation_code
      t.boolean :confirmed
      t.string :callback_code

      t.timestamps
    end
  end
end
