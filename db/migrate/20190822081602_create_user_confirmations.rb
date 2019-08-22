class CreateUserConfirmations < ActiveRecord::Migration[5.2]
  def change
    create_table :user_confirmations do |t|
      t.integer :user_id
      t.integer :confirm_status
      t.string :hash

      t.timestamps
    end
  end
end
