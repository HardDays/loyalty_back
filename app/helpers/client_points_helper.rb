module ClientPointsHelper

    def self.create_from_promotion(client, order, promotion, write_off_points)
        if promotion.begin_date <= DateTime.now && promotion.end_date >= DateTime.now
            return create(client, order, promotion, write_off_points) != nil
        end
    end

    def self.create_from_program(client, order, program, write_off_points)
        if program
            sum = client.orders.sum{|o| o.price} + order.price
            program.loyalty_levels.order(min_price: :desc).each do |level|
                if (level.level_type.to_sym == :one_buy && order.price >= level.min_price) || (level.level_type.to_sym == :sum_buy && sum >= level.min_price)
                    client_points = create(client, order, level, write_off_points)
                    if client_points
                        if level.sms_on_burning
                            if level.burning_rule.to_sym == :burning_days
                                burning_date = DateTime.now + level.burning_days.days
                                notification = ClientSms.new(sms_type: :points_burned, send_at: burning_date - level.sms_burning_days.days)
                                notification.sms_status = :pending
                                notification.client_point = client_points
                                notification.client = client
                                notification.save
                            end
                        end

                        if level.sms_on_points
                            notification = ClientSms.new(sms_type: :points_accrued, send_at: client_points.activation_date)
                            notification.client_point = client_points
                            notification.client = client
                            if level.activation_rule.to_sym == :activation_days
                                notification.sms_status = :pending
                            else
                                notification.sms_status = :sent
                                SmsHelper.send_points_receive(client, points)
                            end
                            notification.save
                        end
                        return true
                    end
                end
            end
        end
        return false
    end

    def self.create(client, order, level, write_off_points)
        if (level.accrual_on_points && write_off_points) || !write_off_points
            points = 0
            if level.accrual_rule.to_sym == :accrual_percent
                points = (order.price * level.accrual_percent) / 100.0
            elsif level.accrual_rule.to_sym == :accrual_convert
                points = order.price * (level.accrual_points / level.accrual_money.to_f)
            end
            points = points.to_i

            activation_date = DateTime.now
            if level.activation_rule.to_sym == :activation_days
                activation_date += level.activation_days.days
            end

            burning_date = DateTime.now + 100.years
            if level.burning_rule.to_sym == :burning_days
                burning_date = DateTime.now + level.burning_days.days
            end

            rest = points % 100
            if level.rounding_rule.to_sym == :rounding_math
                points = points - rest
                if rest >= 50
                    points += 100
                end
            elsif level.rounding_rule.to_sym == :rounding_small
                points = points - rest
            elsif level.rounding_rule.to_sym == :rounding_big 
                points = (points - rest) + 100
            end
            
            client_points = ClientPoint.new(
                current_points: points,
                initial_points: points,
                burning_date: burning_date,
                activation_date: activation_date,
                client: client,
                order: order,
                loyalty_level: level,
                points_source: :ordered
            )
            saved = client_points.save
            if saved 
                if write_off_points
                    self.write_off(order, write_off_points)
                end         
            end
            return client_points
        end
    end


    def self.find_write_off_level(client, program, price)
        points = client.valid_points
        total = points.sum(:current_points)
        sum = client.orders.sum(:price) + price
        program.loyalty_levels.order(min_price: :desc).each do |level|
            if (level.level_type.to_sym == :one_buy && price >= level.min_price) || (level.level_type.to_sym == :sum_buy && sum >= level.min_price)
                if level.write_off_rule.to_sym == :write_off_convert && total >= level.write_off_rule_points
                    return level
                end
            end
        end
        return nil
    end

    def self.points_info(client, price)
        program = client.loyalty_program
        level = self.find_write_off_level(client, program, price)
        if level
            total = client.valid_points.sum(:current_points)
            money = ((order.price * level.write_off_rule_percent) / 100.0)
            points = [money, total].min.to_i
            return {points: points}
        end
        return {points: 0}
    end

    def self.write_off(order, write_off_points)
        program = order.loyalty_program
        client = order.client
        if program && order.write_off_status.to_sym == :not_written_off
            level = self.find_write_off_level(client, program, order.price)
            if level
                points = client.valid_points
                total = client.valid_points.sum(:current_points)
                money = ((order.price * level.write_off_rule_percent) / 100.0)
                current_points = [0, [write_off_points, money, total].min.to_i].max.to_i
           
                if level.sms_on_write_off
                    notification = ClientSms.new(sms_type: :points_writen_off, send_at: DateTime.now)
                    notification.client = client
                    notification.sms_status = :sent
                    notification.save
                    SmsHelper.send_points_write_off(client, current_points)
                end

                points.each do |p|
                    if p.current_points >= current_points
                        p.current_points -= current_points
                        current_points = 0
                        p.save
                    else 
                        current_points -= p.current_points
                        p.current_points = 0
                        p.save
                    end
                    if current_points <= 0
                        break
                    end
                end
                order.write_off_status = :written_off
                order.write_off_points = [0, [write_off_points, money, total].min.to_i].max.to_i
                order.save
                return true
            end
        end
        return false
    end

    def burn
    end
end