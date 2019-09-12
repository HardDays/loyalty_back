module SmsHelper    

    def self.send_notifications
        notifications = ClientSms.where('send_at <= ?', DateTime.now).where(sms_status: :pending)
        notifications.each do |notif|
            if notif.sms_type.to_sym == :points_burned
                if notif.client_point.current_points > 0
                    send_points_burn(notif.client, notif.client_point.current_points, notif.client_point.burning_date)
                    notif.sms_status = :sent
                    notif.save
                end
            elsif notif.sms_type.to_sym == :points_accrued
                send_points_receive(notif.client, notif.client_point.current_points)
                notif.sms_status = :sent
                notif.save
            end
        end
    end

    def self.send_points_write_off(client, points)
        send(client.user.phone, "You written off #{points} bonus points")
    end

    def self.send_points_burn(client, points, date)
        send(client.user.phone, "#{points} points will be burned off at #{date}")
    end

    def self.send_points_receive(client, points)
        send(client.user.phone, "You received #{points} bonus points")
    end

    def self.send_register(client, password)
        send(client.user.phone, "You regeistered in bonus points system. Your password is #{password}")
    end

    def self.send(phone, message)
        puts '##########################'
        puts '##########################'
        puts '##########################'
        puts '##########################'
        puts '##########################'
        puts 'SMS SENT TO ' + phone + ' ' + message
        puts '##########################'
        puts '##########################'
        puts '##########################'
        puts '##########################'
        puts '##########################'
    end

end