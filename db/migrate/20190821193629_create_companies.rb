class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :email
      t.string :password
      t.string :password_confirm
      t.text :company_hash
      t.boolean :is_validate

      t.timestamps
    end
  end
end
