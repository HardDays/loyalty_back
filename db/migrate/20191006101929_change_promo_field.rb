class ChangePromoField < ActiveRecord::Migration[5.2]
  def change
    rename_column :promotions, :date_from, :begin_date
    rename_column :promotions, :date_to, :end_date
    add_column :promotions, :company_id, :integer

  end
end
