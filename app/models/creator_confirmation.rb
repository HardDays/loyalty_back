class CreatorConfirmation < ApplicationRecord

    belongs_to :creator

    enum confirm_status: [:unconfirmed, :confirmed]
end
