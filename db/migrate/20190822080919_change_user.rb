class ChangeUser < ActiveRecord::Migration[5.2]
  def change
    # подтверждение пароля не надо хранить, его достаточно проверить 1 раз при реге / апдейте
    remove_column :users, :password_confirm
    # это нужно для шифрования пароля
    rename_column :users, :password, :password_digest
    # лучше хранить в отдельной табилце
    remove_column :users, :company_hash
    remove_column :users, :is_validate
    # тип пользователя
    add_column :users, :user_type, :integer
    # ключ
    rename_column :company_infos, :company_id, :user_id

  end
end
