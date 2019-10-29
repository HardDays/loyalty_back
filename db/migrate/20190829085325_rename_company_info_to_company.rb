class RenameCompanyInfoToCompany < ActiveRecord::Migration[5.2]
  def change
    rename_table :company_infos, :companies
  end
end
