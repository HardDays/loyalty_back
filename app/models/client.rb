class Client < ApplicationRecord

  belongs_to :company
  belongs_to :user
  belongs_to :loyalty_program, optional: true

  has_many :orders, dependent: :nullify
  
end
