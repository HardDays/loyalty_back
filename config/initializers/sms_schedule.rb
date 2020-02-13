scheduler = Rufus::Scheduler.new

scheduler.cron '12 00 * * * Europe/Moscow' do
    begin
        puts 'sending sms'
        SmsHelper.send_notifications
    rescue => ex
        puts 'sms error', ex
    end
end

scheduler.every '10s' do
    puts 'aaaaaa'
end