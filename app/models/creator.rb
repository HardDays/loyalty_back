class Creator < ApplicationRecord

  has_one :company
  belongs_to :user


  def as_json(options = {})
    attrs = super.except('user_id').except('id')

    attrs[:user_type] = :creator

    attrs.except('user_id')
  end
end
