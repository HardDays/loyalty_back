module ClientPointsHelper

    def self.create_from_promotion(client, order, promotion, write_off_points)
        if promotion.begin_date <= DateTime.now && promotion.end_date >= DateTime.now
            if (promotion.accrual_on_points && write_off_points) || !write_off_points
                points = 0
                price = order.price
                if write_off_points
                    total = client.valid_points.sum(:current_points)
                    money = ((order.price * promotion.write_off_rule_percent) / 100.0)
                    price = [0, [write_off_points, money, total].min.to_i].max.to_i
                end
                if promotion.accrual_rule.to_sym == :accrual_percent
                    points = (price * promotion.accrual_percent) / 100.0
                elsif promotion.accrual_rule.to_sym == :accrual_convert
                    points = price * (promotion.accrual_points / promotion.accrual_money.to_f)
                end
                points = points.to_i
    
                activation_date = DateTime.now
                if promotion.activation_rule.to_sym == :activation_days
                    activation_date += promotion.activation_days.days
                end
    
                burning_date = DateTime.now + 100.years
                if promotion.burning_rule.to_sym == :burning_days
                    burning_date = DateTime.now + promotion.burning_days.days
                end
    
                rest = points % 100
                if promotion.rounding_rule.to_sym == :rounding_math
                    points = points - rest
                    if rest >= 50
                        points += 100
                    end
                elsif promotion.rounding_rule.to_sym == :rounding_small
                    points = points - rest
                elsif promotion.rounding_rule.to_sym == :rounding_big 
                    points = (points - rest) + 100
                end
                
                client_points = ClientPoint.new(
                    current_points: points,
                    initial_points: points,
                    burning_date: burning_date,
                    activation_date: activation_date,
                    client: client,
                    order: order,
                    promotion: promotion,
                    points_source: :ordered
                )
                if client_points.save
                    if write_off_points
                        write_off_promotion(order, write_off_points, promotion)
                    end
                    return true
                end
            end
        end
    end

    def self.create_from_program(client, order, program, write_off_points)
        if program
            sum = client.orders.sum{|o| o.price} + order.price
            program.loyalty_levels.order(min_price: :desc).each do |level|
                if (program.sum_type.to_sym == :one_buy && order.price >= level.min_price) || (program.sum_type.to_sym == :sum_buy && sum >= level.min_price)
                    if (level.accrual_on_points && write_off_points) || !write_off_points
                        points = 0
                        price = order.price
                        if write_off_points
                            total = client.valid_points.sum(:current_points)
                            money = ((order.price * level.write_off_rule_percent) / 100.0)
                            price = [0, [write_off_points, money, total].min.to_i].max.to_i
                        end
                        if level.accrual_rule.to_sym == :accrual_percent
                            points = (price * level.accrual_percent) / 100.0
                        elsif level.accrual_rule.to_sym == :accrual_convert
                            points = price * (level.accrual_points / level.accrual_money.to_f)
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
                        if program.rounding_rule.to_sym == :rounding_math
                            points = points - rest
                            if rest >= 50
                                points += 100
                            end
                        elsif program.rounding_rule.to_sym == :rounding_small
                            points = points - rest
                        elsif program.rounding_rule.to_sym == :rounding_big 
                            if rest > 0
                                points = (points - rest) + 100
                            end
                        end
                        
                        client_points = ClientPoint.new(
                            current_points: points,
                            initial_points: points,
                            burning_date: burning_date,
                            activation_date: activation_date,
                            client: client,
                            order: order,
                            loyalty_level: level,
                            loyalty_program: program,
                            points_source: :ordered
                        )
                        if client_points.save
                            if program.sms_on_burning
                                if level.burning_rule.to_sym == :burning_days
                                    burning_date = DateTime.now + level.burning_days.days
                                    notification = ClientSms.new(sms_type: :points_burned, send_at: burning_date - program.sms_burning_days.days)
                                    notification.sms_status = :pending
                                    notification.client_point = client_points
                                    notification.client = client
                                    notification.save
                                end
                            end

                            if program.sms_on_points
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
                        end
                    end
                    if write_off_points
                        write_off_program(order, write_off_points)
                    end
                    return true
                end
            end
        end
        return false
    end

    def self.points_info_promotion(client, price, promotion)
        total = client.valid_points.sum(:current_points)
        if promotion
            if !promotion.write_off_limited || (promotion.write_off_limited && promotion.write_off_min_price <= price)
                if promotion.write_off_rule.to_sym == :write_off_convert && total >= promotion.write_off_rule_points
                    money = (price * promotion.write_off_rule_percent) / 100.0
                    points = [money, total].min.to_i
                    return {points: points}
                end
            end
        end
        return {points: 0}
    end

    def self.points_info_program(client, price)
        program = client.loyalty_program
        level = self.find_level(client, program, price)
        if level
            total = client.valid_points.sum(:current_points)
            money = ((price * level.write_off_rule_percent) / 100.0)
            points = [money, total].min.to_i
            return {points: points}
        end
        return {points: 0}
    end

    def self.write_off_promotion(order, write_off_points, promotion)
        client = order.client
        total = client.valid_points.sum(:current_points)
        if promotion
            if !promotion.write_off_limited || (promotion.write_off_limited && promotion.write_off_min_price <= order.price)
                if promotion.write_off_rule.to_sym == :write_off_convert && total >= promotion.write_off_rule_points
                    if order.write_off_status.to_sym == :not_written_off
                        return self.write_off(order, write_off_points, promotion)
                    end
                end
            end
        end
    end

    def self.write_off_program(order, write_off_points)
        program = order.loyalty_program
        client = order.client
        if program && order.write_off_status.to_sym == :not_written_off
            level = self.find_level(client, program, order.price)
            if self.write_off(order, write_off_points, level)
                if program.sms_on_write_off
                    points = client.valid_points
                    total = client.valid_points.sum(:current_points)
                    money = ((order.price * level.write_off_rule_percent) / 100.0)
                    current_points = [0, [write_off_points, money, total].min.to_i].max.to_i

                    notification = ClientSms.new(sms_type: :points_writen_off, send_at: DateTime.now)
                    notification.client = client
                    notification.sms_status = :sent
                    notification.save
                    SmsHelper.send_points_write_off(client, current_points)
                    return true
                end
            end
        end
        return false
    end

    def self.write_off(order, write_off_points, level)
        client = order.client
        total = client.valid_points.sum(:current_points)
        money = ((order.price * level.write_off_rule_percent) / 100.0)
        current_points = [0, [write_off_points, money, total].min.to_i].max.to_i
        self.write_off_number(client, current_points)
        # points.each do |p|
        #     if p.current_points >= current_points
        #         p.current_points -= current_points
        #         current_points = 0
        #         p.save
        #     else 
        #         current_points -= p.current_points
        #         p.current_points = 0
        #         p.save
        #     end
        #     if current_points <= 0
        #         break
        #     end
        # end
        order.write_off_status = :written_off
        order.write_off_points = [0, [write_off_points, money, total].min.to_i].max.to_i
        order.save
        return true
    end

    def self.write_off_number(client, number)
        points = client.valid_points
        current_points = number
    
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
    end

    def self.find_level(client, program, price)
        points = client.valid_points
        total = points.sum(:current_points)
        sum = client.orders.sum(:price) + price
        if !program.write_off_limited || (program.write_off_limited && program.write_off_min_price <= price)
            program.loyalty_levels.order(min_price: :desc).each do |level|
                if (program.sum_type.to_sym == :one_buy && price >= level.min_price) || (program.sum_type.to_sym == :sum_buy && sum >= level.min_price)
                    if level.write_off_rule.to_sym == :write_off_convert && total >= level.write_off_rule_points
                        return level
                    end
                end
            end
        end
        return nil
    end

    def burn
        #TODO: finish
    end
end