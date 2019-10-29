class UpdateModels < ActiveRecord::Migration[5.2]
  def change
    #надо тоже знать, к какой компании они принадлежат
    add_column :clients, :company_id, :integer
    add_column :operators, :company_id, :integer

    add_column :clients, :user_id, :integer
    add_column :operators, :user_id, :integer
    add_column :creators, :user_id, :integer

    add_column :users, :first_name, :string
    add_column :users, :second_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :string
    
    add_column :stores, :country, :string
    add_column :stores, :city, :string
    add_column :stores, :street, :string
    add_column :stores, :house, :string

    remove_column :stores, :address

    remove_column :creators, :password_confirm
    remove_column :clients, :password_confirm
    remove_column :operators, :password_confirm

    remove_column :creators, :password
    remove_column :clients, :password
    remove_column :operators, :password

    remove_column :creators, :firstname
    remove_column :creators, :lastname
    remove_column :creators, :secondname
    remove_column :creators, :email

    remove_column :clients, :firstname
    remove_column :clients, :lastname
    remove_column :clients, :secondname
    remove_column :clients, :email
    remove_column :clients, :phone

    remove_column :operators, :firstname
    remove_column :operators, :lastname
    remove_column :operators, :secondname
    remove_column :operators, :email

  end
end
