class CreateCallBacks < ActiveRecord::Migration[6.0]
  def change
    create_table :call_backs do |t|
      t.integer :company_id
      t.string :phone
      t.integer :status

      t.timestamps
    end
  end
end
