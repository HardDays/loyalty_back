class TelegramGroup < ApplicationRecord
    belongs_to :company
    validates :join_points, inclusion: 0..10000000000

end
