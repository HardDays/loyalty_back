class LoyaltyProgram < ApplicationRecord

    belongs_to :company

    has_many :loyalty_levels, dependent: :destroy
    has_many :orders, dependent: :nullify

    enum sum_type: [:one_buy, :sum_buy]

    validates :name, length: {minimum: 1, maximum: 128}
    validates :sum_type, presence: :true
    
    def ownership(creator)
        if creator.company != self.company
            raise ApplicationController::Forbidden
        end
    end

    def serializable_hash(options = {})
        attrs = super

        if options
            if options[:loyalty_levels]
                attrs[:loyalty_levels] = loyalty_levels
            end
        end

        return attrs
    end
end
