class Promotion < ApplicationRecord

  belongs_to :company

  has_many :loyalty_levels

  validates :name, length: {minimum: 1, maximum: 128}
  validates :loyalty_levels, length: {minimum: 1}
    
  validates :begin_date, presence: :true
  validates :end_date, presence: true, date: {after_or_equal_to: :begin_date}

  def ownership(creator)
    if creator.company != self.company
        raise ApplicationController::Forbidden
    end
  end

  def serializable_hash(options = {})
    attrs = super

    if options && options[:loyalty_levels]
        attrs[:loyalty_levels] = loyalty_levels
    end

    return attrs
  end

end
