class CreateCompanyBans < ActiveRecord::Migration[5.2]
  def change
    create_table :company_bans do |t|
      t.integer :company_id

      t.timestamps
    end
  end
end
