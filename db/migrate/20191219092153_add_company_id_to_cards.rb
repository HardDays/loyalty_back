class AddCompanyIdToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :company_id, :integer
  end
end
