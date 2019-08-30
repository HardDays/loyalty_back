class Operator < ApplicationRecord
  
  belongs_to :store, optional: true
  belongs_to :company
  belongs_to :user

end
