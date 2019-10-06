class CreatePromotions < ActiveRecord::Migration[5.2]
  def change
    create_table :promotions do |t|
      t.string :title
      t.datetime :date_from
      t.datetime :date_to

      t.timestamps
    end
  end
end
