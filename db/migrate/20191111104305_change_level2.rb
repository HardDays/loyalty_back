class ChangeLevel2 < ActiveRecord::Migration[5.2]
  def change
    add_column :loyalty_programs, :accrual_on_recommend, :boolean
    remove_column :loyalty_levels, :accrual_on_recommend, :boolean
  end
end
