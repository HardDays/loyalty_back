class ChangeRecommendator < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :recommendator_id, :integer
    remove_column :users, :recommendator_id, :integer
  end
end
