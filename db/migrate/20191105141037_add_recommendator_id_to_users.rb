class AddRecommendatorIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :recommendator_id, :integer
  end
end
