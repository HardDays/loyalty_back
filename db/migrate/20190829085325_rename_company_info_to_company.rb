class RenameCompanyInfoToCompany < ActiveRecord::Migration[6.0]
  def change
    rename_table :company_infos, :companies
  end
end
