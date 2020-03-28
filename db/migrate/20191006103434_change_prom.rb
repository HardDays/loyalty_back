class ChangeProm < ActiveRecord::Migration[5.2]
  def change
    rename_column :promotions, :title, :name

  end
end
