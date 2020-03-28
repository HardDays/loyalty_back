class ClientSms < ApplicationRecord
    belongs_to :client_point, optional: true
    belongs_to :client

    enum sms_type: [:points_burned, :points_accrued, :points_writen_off, :registered, :points_recommended]
    enum sms_status: [:pending, :sent, :error]

end
