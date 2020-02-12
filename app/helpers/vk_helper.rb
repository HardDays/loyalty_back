module VkHelper

    TOKEN = ''

    def self.find_likes(group)
        vk = VkontakteApi::Client.new(TOKEN)
        posts = vk.wall.get(owner: group.group_id)
    end

end