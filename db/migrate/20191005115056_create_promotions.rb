class CreatePromotions < ActiveRecord::Migration[6.0]
  def change
    create_table :promotions do |t|
      t.string :title
      t.datetime :date_from
      t.datetime :date_to

      t.timestamps
    end
  end
end
