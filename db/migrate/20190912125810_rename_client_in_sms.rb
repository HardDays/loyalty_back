class RenameClientInSms < ActiveRecord::Migration[5.2]
  def change
    rename_column :client_sms, :client_points_id, :client_point_id

  end
end
