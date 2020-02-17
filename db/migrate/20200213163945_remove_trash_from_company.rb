class RemoveTrashFromCompany < ActiveRecord::Migration[5.2]
  def change
    remove_column :companies, :legal_entity, :string
    remove_column :companies, :bic, :string
    remove_column :companies, :inn, :string
    remove_column :companies, :bank, :integer
    remove_column :companies, :invoice, :string
    remove_column :companies, :kpp, :string
    remove_column :companies, :checking_account, :string
    remove_column :companies, :phone, :string
    remove_column :companies, :web_site, :string
  end
end
