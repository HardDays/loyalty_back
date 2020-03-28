class Creator < ApplicationRecord

  has_one :company
  belongs_to :user

  validates :user, uniqueness: { scope: [:company] }

  def as_json(options = {})
    attrs = super.except('user_id').except('id')

    attrs[:company] = company

    return attrs.except('user_id')
  end
end
