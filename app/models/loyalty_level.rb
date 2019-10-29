class LoyaltyLevel < ApplicationRecord
    #TODO: proverka
    belongs_to :loyalty_program

    has_many :client_points, dependent: :nullify

    enum level_type: [:one_buy, :sum_buy]
    enum accrual_rule: [:no_accrual, :accrual_percent, :accrual_convert]
    enum burning_rule: [:no_burning, :burning_days]
    enum activation_rule: [:activation_moment, :activation_days]
    enum write_off_rule: [:no_write_off, :write_off_convert]
    enum accordance_rule: [:no_accordance, :accordance_convert]
    enum rounding_rule: [:no_rounding, :rounding_math, :rounding_small, :rounding_big]

    validates :level_type, presence: :true
    validates :accrual_rule, presence: :true
    validates :burning_rule, presence: :true
    validates :activation_rule, presence: :true
    validates :write_off_rule, presence: :true
    validates :accordance_rule, presence: :true
    validates :rounding_rule, presence: :true

    validates :min_price, inclusion: 1..10000000
    validates :accrual_percent, inclusion: 1..100, if: lambda {|m| m.accrual_rule == 'accrual_percent'}
    validates :accrual_points, inclusion: 1..10000000, if: lambda {|m| m.accrual_rule == 'accrual_convert'}
    validates :accrual_money, inclusion: 1..10000000, if: lambda {|m| m.accrual_rule == 'accrual_convert'}
    validates :burning_days, inclusion: 1..365, if: lambda {|m| m.burning_rule == 'burning_days'}
    validates :activation_days, inclusion: 1..365, if: lambda {|m| m.activation_rule == 'activation_days'}
    validates :write_off_rule_percent, inclusion: 1..100, if: lambda {|m| m.write_off_rule == 'write_off_convert'}
    validates :write_off_rule_points, inclusion: 1..10000000, if: lambda {|m| m.write_off_rule == 'write_off_convert'}
    validates :accordance_percent, inclusion: 1..100, if: lambda {|m| m.accordance_rule == 'accordance_convert'}
    validates :accordance_points, inclusion: 1..10000000, if: lambda {|m| m.accordance_rule == 'accordance_convert'}

    validates :accrual_on_points, inclusion: {in: [true, false]}
    validates :accrual_on_register, inclusion: {in: [true, false]}
    validates :accrual_on_first_buy, inclusion: {in: [true, false]}
    #validates :accrual_on_birthday, inclusion: {in: [true, false]}
    validates :write_off_limited, inclusion: {in: [true, false]}
    validates :accrual_on_recommend, inclusion: {in: [true, false]}

    validates :register_points, inclusion: 1..10000000, if: lambda {|m| m.accrual_on_register}
    validates :first_buy_points, inclusion: 1..10000000, if: lambda {|m| m.accrual_on_first_buy}
    #validates :birthday_points, inclusion: 1..10000000, if: lambda {|m| m.accrual_on_birthday}
    validates :write_off_min_price, inclusion: 1..10000000, if: lambda {|m| m.write_off_limited}
    validates :recommend_recommendator_points, inclusion: 1..10000000, if: lambda {|m| m.accrual_on_recommend}
    validates :recommend_registered_points, inclusion: 1..10000000, if: lambda {|m| m.accrual_on_recommend}

    validates :sms_on_register, inclusion: {in: [true, false]}
    validates :sms_on_points, inclusion: {in: [true, false]}
    validates :sms_on_write_off, inclusion: {in: [true, false]}
    validates :sms_on_burning, inclusion: {in: [true, false]}
    validates :sms_on_birthday, inclusion: {in: [true, false]}

    validates :sms_burning_days, inclusion: 1..365, if: lambda {|m| m.sms_on_burning}

end
