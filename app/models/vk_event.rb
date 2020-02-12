class VkEvent < ApplicationRecord
    belongs_to :vk_group
    belongs_to :client

    validates :post_id, length: {minimum: 1, maximum: 128}, allow_nil: true

    enum event_type: [:group_join, :wall_repost, :wall_like, :wall_reply_new]
end
