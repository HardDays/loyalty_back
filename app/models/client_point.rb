class ClientPoint < ApplicationRecord
    belongs_to :client
    belongs_to :order
    belongs_to :loyalty_level

    validates :activation_date, presence: :true
    validates :burning_date, presence: :true
    validates :points, inclusion: 0..1000000000

end
