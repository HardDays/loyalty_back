class ClientPoint < ApplicationRecord
    belongs_to :client
    belongs_to :order
    belongs_to :loyalty_level, optional: true
    belongs_to :promotion, optional: true

    validates :activation_date, presence: :true
    validates :burning_date, presence: :true
    validates :initial_points, inclusion: 0..10000000000
    validates :current_points, inclusion: 0..10000000000

    enum points_source: [:ordered, :birthday]

end
