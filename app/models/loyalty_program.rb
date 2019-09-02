class LoyaltyProgram < ApplicationRecord

    belongs_to :company

    has_many :loyalty_levels, dependent: :destroy
    has_many :orders, dependent: :nullify

    validates :name, length: {minimum: 1, maximum: 128}
    validates :loyalty_levels, length: {minimum: 1}
    
    def ownership(creator)
        if creator.company != self.company
            raise ApplicationController::Forbidden
        end
    end

    def serializable_hash(options = {})
        attrs = super
        
        attrs[:loyalty_levels] = loyalty_levels

        attrs
    end
end
