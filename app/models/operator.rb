class Operator < ApplicationRecord
  
  belongs_to :store, optional: true
  belongs_to :company
  belongs_to :user

  has_many :orders, dependent: :nullify

  enum operator_status: [:active, :deleted]

  def as_json(options = {})
    attrs = super.except('user_id').except('id')

    attrs[:user_type] = :operator

    return attrs
  end
end
