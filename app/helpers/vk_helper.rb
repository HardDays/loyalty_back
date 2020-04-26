module VkHelper

    TOKEN = Rails.configuration.vk_token

    def self.check_likes
        groups = VkGroup.all
        
        groups.each do |group|
            begin
                id = -(group.group_id.to_i)
                vk = VkontakteApi::Client.new(TOKEN)
                posts = vk.wall.get(owner_id: id, v: '5.103').items
                puts '##############'
                puts id
                puts json: posts
                puts '##############'

                posts.each do |p|
                    likes = vk.likes.getList(type: 'post', owner_id: id, item_id: p.id, v: '5.103').items
                    likes.each do |like|
                        client = Client.find_by(vk_id: like)
                        if client
                            event = VkEvent.new(client_id: client.id, vk_group_id: group.id, event_type: :wall_like, post_id: p.id)
                            if event.save
                                points = ClientPoint.new(
                                    current_points: group.wall_like_points,
                                    initial_points: group.wall_like_points,
                                    burning_date: DateTime.now + 100.years,
                                    activation_date: DateTime.now,
                                    client_id: client.id,
                                    points_source: :vk
                                )
                                points.save
                            end
                        end
                    end
                end
            end
        rescue Exception => ex
        end
    end
end