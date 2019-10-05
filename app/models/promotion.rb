class Promotion < ApplicationRecord

  belongs_to :loyalty_level

  validates :title, presence: :true
  validates :date_from, presence: :true
  validates :date_to, presence: true, date: {after_or_equal_to: :date_from}

end
