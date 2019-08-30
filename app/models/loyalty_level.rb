class LoyaltyLevel < ApplicationRecord
    
    belongs_to :loyalty_program

    enum level_type: [:one_buy, :sum_buy]
    enum accrual_rule: [:no_accrual, :accrual_percent, :accrual_convert]
    enum burning_rule: [:no_burning, :burning_days]
    enum activation_rule: [:accrual_moment, :activation_days]
    enum write_off_rule: [:no_write_off, :write_off_convert]
    enum accordance_rule: [:no_accordance, :accordance_convert]
    enum rounding_rule: [:no_rounding, :rounding_math, :rounding_small, :rounding_big]

    validates :accrual_percent, inclusion: 1..100, if: lambda {|m| m.accrual_rule.to_sym == :accrual_percent}
    validates :accrual_points, inclusion: 1..100000 if: lambda {|m| m.accrual_rule.to_sym == :accrual_convert}
    validates :accrual_money, inclusion: 1..100000 if: lambda {|m| m.accrual_rule.to_sym == :accrual_convert}
    validates :burning_days, inclusion: 1..365 if: lambda {|m| m.burning_rule.to_sym == :burning_days}
    validates :activation_days, inclusion: 1..365 if: lambda {|m| m.activation_rule.to_sym == :activation_days}
    validates :write_off_percent, inclusion: 1..100, if: lambda {m| m.write_off_rule.to_sym == :write_off_convert}
    validates :write_off_points, inclusion: 1..100000 if: lambda {|m| m.write_off_rule.to_sym == :write_off_convert}
    validates :accordance_percent, inclusion: 1..100, if: lambda {|m| m.accordance_rule.to_sym == :write_off_convert}
    validates :accordance_points, inclusion: 1..100000 if: lambda {|m| m.accordance_rule.to_sym == :accordance_convert}

    validates :accrual_on_points, presence: :true
    validates :accrual_on_register, presence: :true
    validates :accrual_on_first_buy, presence: :true
    validates :accrual_on_birthday, presence: :true

    validates :register_points, inclusion: 1..100000 if: lambda {|m| m.accrual_on_register}
    validates :first_buy_points, inclusion: 1..100000 if: lambda {|m| m.accrual_on_first_buy}
    validates :birthday_points, inclusion: 1..100000 if: lambda {|m| m.accrual_on_birthday}

    validates :sms_on_register, presence: :true
    validates :sms_on_points, presence: :true
    validates :sms_on_write_off, presence: :true
    validates :sms_on_burning, presence: :true

    validates :sms_burning_days, inclusion: 1..365 if: lambda {|m| m.sms_on_burning}

end
