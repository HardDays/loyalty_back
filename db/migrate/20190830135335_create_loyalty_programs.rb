class CreateLoyaltyPrograms < ActiveRecord::Migration[5.2]
  def change
    create_table :loyalty_programs do |t|
      t.integer :company_id
      t.string :name

      t.timestamps
    end
  end
end
