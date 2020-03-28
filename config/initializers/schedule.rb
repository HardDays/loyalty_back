scheduler = Rufus::Scheduler.new

scheduler.cron '12 00 * * * Europe/Moscow' do
    begin
        puts 'sending sms'
        #SmsHelper.send_notifications
    rescue => ex
        puts 'sms error', ex
    end
end

scheduler.every '1h' do
    begin
        VkHelper.check_likes
    rescue => ex
        puts 'vk likes error', ex
    end
end