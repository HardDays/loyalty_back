class RemoveTrashFromCompany2 < ActiveRecord::Migration[5.2]
  def change
    remove_column :companies, :postcode, :string
  end
end
