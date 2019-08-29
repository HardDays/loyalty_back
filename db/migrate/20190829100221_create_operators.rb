class CreateOperators < ActiveRecord::Migration[5.2]
  def change
    create_table :operators do |t|
      t.string :email
      t.string :password
      t.string :password_confirm
      t.integer :store_id
      t.string :firstname
      t.string :secondname
      t.string :lastname

      t.timestamps
    end
  end
end
