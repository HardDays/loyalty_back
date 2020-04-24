class CreateServiceTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :service_tokens do |t|
      t.integer :company_id
      t.string :one_s

      t.timestamps
    end
  end
end
