class VkGroup < ApplicationRecord
    belongs_to :company

    validates :confirmation_code, length: {minimum: 1, maximum: 32}
    validates :confirmed, inclusion: {in: [true, false]}
    validates :group_id, length: {minimum: 1, maximum: 256}
    validates :group_join_points, inclusion: 0..10000000000
    validates :wall_repost_points, inclusion: 0..10000000000
    validates :wall_like_points, inclusion: 0..10000000000
    validates :wall_reply_points, inclusion: 0..10000000000

    has_many :vk_events

end
