class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :email
      t.string :password
      t.string :password_confirm
      t.string :phone
      t.string :firstname
      t.string :secondname
      t.string :lastname

      t.timestamps
    end
  end
end
