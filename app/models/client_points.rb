class ClientPoints < ApplicationRecord
    belongs_to :client
    belongs_to :order
    belongs_to :loyalty_program

    validates :activation_date, presence: :true
    validates :burning_date, presence: :true
    validates :points, inclusion: 0..1000000000

end
