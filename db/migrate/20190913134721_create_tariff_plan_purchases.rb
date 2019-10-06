# class CreateTariffPlanPurchases < ActiveRecord::Migration[5.2]
#   def change
#     create_table :tariff_plan_purchases do |t|
#       t.integer :tariff_plan_id
#       t.date :expired_at

#       t.timestamps
#     end
#     rename_column :companies, :tariff_plan_id, :tariff_plan_purchase_id
#   end
# end
