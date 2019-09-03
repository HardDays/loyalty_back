class SmsNotification < ApplicationRecord
    belongs_to :client_points, optional: true
    belongs_to :user

    enum sms_type: [:points_accrual, :points_write_off, :points_burn]


    def send

    end
end
