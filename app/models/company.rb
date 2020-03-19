class Company < ApplicationRecord
    belongs_to :creator
    #belongs_to :tariff_plan_purchase
    has_one :loyalty_program
    has_one :vk_group
    has_one :telegram_group
    has_one :service_token

    has_many :operators
    has_many :clients
    has_many :stores
    has_many :promotions

    validates :creator_id, uniqueness: true
    
    validates :name, length: {minimum: 1, maximum: 128}

    def valid_token?(token)
        puts 'AAAAAAAAAAAAAAAAAA'
        puts json: service_token
        if (not service_token) || service_token.one_s != token 
            raise ApplicationController::Forbidden
        end
    end

    def as_json(options={})
        attrs = super.except('creator_id')

        #attrs[:tariff_plan] = tariff_plan_purchase.tariff_plan.as_json.merge({expired_at: tariff_plan_purchase.expired_at})

        return attrs
    end

end
