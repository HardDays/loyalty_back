class TelegramEvent < ApplicationRecord
    belongs_to :telegram_group
    belongs_to :client

    enum event_type: [:group_join]

    validates :client, uniqueness: { scope: [:telegram_group] }

end
