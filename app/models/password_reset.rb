class PasswordReset < ApplicationRecord
    belongs_to :user

    enum confirm_status: [:unconfirmed, :confirmed]
end
