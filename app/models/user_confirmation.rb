class UserConfirmation < ApplicationRecord

    belongs_to :user

    # в базе хранится как integer, но можно обращаться как к строке или символу,
    # магия рельс
    enum confirm_status: [:unconfirmed, :confirmed]
end
