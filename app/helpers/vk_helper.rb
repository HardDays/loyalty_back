module VkHelper

    TOKEN = Rails.configuration.vk_token

    def self.find_likes(group)
        id = -(group.group_id.to_i)

        vk = VkontakteApi::Client.new(TOKEN)
        posts = vk.wall.get(owner_id: id, v: '5.103').items
        posts.each do |p|
            likes = vk.likes.getList(type: 'post', owner_id: id, item_id: p.id, v: '5.103')
            likes.each do |like|
                client = Client.find_by(vk_id: like)
                if client
                    event = VkEvent.new(client_id: client.id, group_id: group.id, event_type :wall_like, post_id: p.id)
                    event.save
                end
            end
        end
    end

end