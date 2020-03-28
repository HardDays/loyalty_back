class Operator < ApplicationRecord
  
    belongs_to :store, optional: true
    belongs_to :company
    belongs_to :user

    has_many :orders, dependent: :nullify

    enum operator_status: [:active, :deleted]

    validates :user, uniqueness: { scope: [:company] }
    validate :validate_store

    def validate_store
        if store.present? && store.company.id != company.id
            errors.add(:store, 'WRONG_FIELD')
        end
    end

    def as_json(options = {})
        attrs = super.except('user_id').except('id')

        #attrs[:user_type] = :operator
        attrs[:company] = company

        return attrs
    end
end
