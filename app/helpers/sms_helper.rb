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
        send(client.user.phone, "Списано #{points} бонусов лояльности")
    end

    def self.send_points_burn(client, points, date)
        send(client.user.phone, "#{points} бонусов сгорят #{date}")
    end

    def self.send_points_receive(client, points)
        send(client.user.phone, "Вы получили #{points} бонусов")
    end

    def self.send_register(client, password)
        send(client.user.phone, "Вы зарегистированы в системе лояльности. Ваш пароль #{password}")
    end

    def self.send(phone, message)
        begin
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
            if Rails.env.development?
                # client = Twilio::REST::Client.new
                #     client.messages.create({
                #         from: Rails.configuration.twilio_phone_number,
                #         to: '+' + phone,
                #         body: message
                #     }
                # )
            end
        rescue => ex
            puts 'AAAAAAAAAAAAAAAAAA'
            puts ex
        end
    end

end