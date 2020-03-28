class RenameLoyaltyPr < ActiveRecord::Migration[5.2]
  def change
    rename_column :loyalty_levels, :loyalty_progam_id, :loyalty_program_id
  end
end
