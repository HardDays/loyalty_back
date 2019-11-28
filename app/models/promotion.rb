class Promotion < ApplicationRecord

  belongs_to :company

  validates :name, length: {minimum: 1, maximum: 128}
    
  validates :begin_date, presence: :true
  validates :end_date, presence: true, date: {after_or_equal_to: :begin_date}

  enum accrual_rule: [:no_accrual, :accrual_percent, :accrual_convert]
  enum burning_rule: [:no_burning, :burning_days]
  enum activation_rule: [:activation_moment, :activation_days]
  enum write_off_rule: [:no_write_off, :write_off_convert]
  enum accordance_rule: [:no_accordance, :accordance_convert]
  enum rounding_rule: [:no_rounding, :rounding_math, :rounding_small, :rounding_big]

  validates :accrual_rule, presence: :true
  validates :burning_rule, presence: :true
  validates :activation_rule, presence: :true
  validates :write_off_rule, presence: :true
  validates :accordance_rule, presence: :true
  validates :rounding_rule, presence: :true

  validates :accrual_percent, inclusion: 0..100, if: lambda {|m| m.accrual_rule == 'accrual_percent'}
  validates :accrual_points, inclusion: 0..10000000, if: lambda {|m| m.accrual_rule == 'accrual_convert'}
  validates :accrual_money, inclusion: 0..10000000, if: lambda {|m| m.accrual_rule == 'accrual_convert'}
  validates :burning_days, inclusion: 1..365, if: lambda {|m| m.burning_rule == 'burning_days'}
  validates :activation_days, inclusion: 1..365, if: lambda {|m| m.activation_rule == 'activation_days'}
  validates :write_off_rule_percent, inclusion: 0..100, if: lambda {|m| m.write_off_rule == 'write_off_convert'}
  validates :write_off_rule_points, inclusion: 0..10000000, if: lambda {|m| m.write_off_rule == 'write_off_convert'}
  validates :accordance_percent, inclusion: 0..100, if: lambda {|m| m.accordance_rule == 'accordance_convert'}
  validates :accordance_points, inclusion: 0..10000000, if: lambda {|m| m.accordance_rule == 'accordance_convert'}

  validates :accrual_on_points, inclusion: {in: [true, false]}
  validates :write_off_limited, inclusion: {in: [true, false]}
  validates :write_off_min_price, inclusion: 0..10000000, if: lambda {|m| m.write_off_limited}

  def ownership(creator)
    if creator.company != self.company
        raise ApplicationController::Forbidden
    end
  end
end
