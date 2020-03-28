class RemoveCompanyIdFromCreators < ActiveRecord::Migration[5.2]
  def change
    remove_column :creators, :company_id, :integer
  end
end
