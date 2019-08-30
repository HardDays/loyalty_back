class LoyaltyProgram < ApplicationRecord

    belongs_to :company
    has_many :loyalty_levels

    validates :name, length: {minimum: 1, maximum: 128}
    validates :loyalty_levels, length: {minimum: 1}

end
