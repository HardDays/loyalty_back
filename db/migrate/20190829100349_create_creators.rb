class CreateCreators < ActiveRecord::Migration[6.0]
  def change
    create_table :creators do |t|
      t.string :email
      t.string :password
      t.string :password_confirm
      t.integer :company_id
      t.string :firstname
      t.string :secondname
      t.string :lastname

      t.timestamps
    end
  end
end
