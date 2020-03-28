class CreateCompanyInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :company_infos do |t|
      t.string :legal_entity
      t.string :postcode
      t.string :inn
      t.string :bic
      t.integer :bank
      t.string :invoice
      t.string :kpp
      t.string :checking_account
      t.string :phone
      t.string :web_site
      t.string :name
      t.integer :company_id

      t.timestamps
    end
  end
end
