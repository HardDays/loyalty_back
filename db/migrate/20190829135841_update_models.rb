class UpdateModels < ActiveRecord::Migration[5.2]
  def change
    #надо тоже знать, к какой компании они принадлежат
    # add_column :clients, :company_id, :integer
    # add_column :operators, :company_id, :integer

    # remove_column :creators, :password_confirm
    # remove_column :clients, :password_confirm
    # remove_column :operators, :password_confirm

    # rename_column :clients, :firstname, :first_name
    # rename_column :clients, :lastname, :last_name
    # rename_column :clients, :secondname, :second_name

    # rename_column :creators, :firstname, :first_name
    # rename_column :creators, :lastname, :last_name
    # rename_column :creators, :secondname, :second_name

    # rename_column :operators, :firstname, :first_name
    # rename_column :operators, :lastname, :last_name
    # rename_column :operators, :secondname, :second_name

  end
end
