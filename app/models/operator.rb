class Operator < ApplicationRecord
  
  belongs_to :store, optional: true
  belongs_to :company
  belongs_to :user

  has_many :orders, dependent: :nullify

end
