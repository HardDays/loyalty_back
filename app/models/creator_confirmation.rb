class CreatorConfirmation < ApplicationRecord

    belongs_to :creator

    # в базе хранится как integer, но можно обращаться как к строке или символу,
    # магия рельс
    enum confirm_status: [:unconfirmed, :confirmed]
end
