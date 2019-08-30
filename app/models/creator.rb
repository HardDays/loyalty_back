class Creator < ApplicationRecord

  has_one :company
  belongs_to :user

end
