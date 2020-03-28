class LoyaltyProgram < ApplicationRecord

    belongs_to :company

    has_many :loyalty_levels, dependent: :destroy
    has_many :orders, dependent: :nullify

    enum sum_type: [:one_buy, :sum_buy]
    enum rounding_rule: [:no_rounding, :rounding_math, :rounding_small, :rounding_big]

    validates :name, length: {minimum: 1, maximum: 128}
    validates :sum_type, presence: :true
    validates :rounding_rule, presence: :true

    validates :accrual_on_register, inclusion: {in: [true, false]}
    validates :accrual_on_first_buy, inclusion: {in: [true, false]}
    validates :write_off_limited, inclusion: {in: [true, false]}
    validates :accrual_on_recommend, inclusion: {in: [true, false]}

    validates :register_points, inclusion: 0..10000000, if: lambda {|m| m.accrual_on_register}
    validates :first_buy_points, inclusion: 0..10000000, if: lambda {|m| m.accrual_on_first_buy}
    validates :write_off_min_price, inclusion: 0..10000000, if: lambda {|m| m.write_off_limited}
    validates :recommend_recommendator_points, inclusion: 0..10000000, if: lambda {|m| m.accrual_on_recommend}
    validates :recommend_registered_points, inclusion: 0..10000000, if: lambda {|m| m.accrual_on_recommend}

    validates :sms_on_register, inclusion: {in: [true, false]}
    validates :sms_on_points, inclusion: {in: [true, false]}
    validates :sms_on_write_off, inclusion: {in: [true, false]}
    validates :sms_on_burning, inclusion: {in: [true, false]}
    validates :sms_on_birthday, inclusion: {in: [true, false]}

    validates :sms_burning_days, inclusion: 1..365, if: lambda {|m| m.sms_on_burning}

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
