class VkGroup < ApplicationRecord
    belongs_to :company

    validates :confirmation_code, length: {minimum: 1, maximum: 32}
    validates :confirmed, inclusion: {in: [true, false]}
    validates :group_id, length: {minimum: 1, maximum: 256}

end
