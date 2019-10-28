class AddSmsOnBirthDayToLoyaltyLevel < ActiveRecord::Migration[5.2]
  def change
    add_column :loyalty_levels, :sms_on_birthday, :boolean
  end
end
