class RenameCompanyToUser < ActiveRecord::Migration[5.2]
  def change
    # переименую таблицу в юзера, т.к. нам надо иметь единую точку логина/авторизации
    # т.е. чуваки на кассе должны логиниться так же как и владелец точки, просто у них
    # будут разные права доступа
    rename_table :companies, :users
  end
end
