class ClientPointsHelper

    def self.create(client, program, order, use_points)
        if program
            sum = client.orders.sum{|o| o.price} + order.price
            program.loyalty_levels.order(min_price: :desc).each do |level|
                if DateTime.now > level.begin_date && DateTime.now < level.end_date
                    if (level.level_type.to_sym == :one_buy && order.price >= level.min_price) || (level.level_type.to_sym == :sum_buy && sum >= level.min_price)
                        if (level.accrual_on_points && use_points) || !use_points
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
                                points_source: :order
                            )
                            client_points.save
                            return true
                        end
                    end
                end
            end
        end
        return false
    end

    def self.find_write_off_level(client, program, order)
        points = client.valid_points
        total = points.sum(:current_points)
        sum = client.orders.sum(:price) + order.price
        program.loyalty_levels.order(min_price: :desc).each do |level|
            if DateTime.now > level.begin_date && DateTime.now < level.end_date
                if (level.level_type.to_sym == :one_buy && order.price >= level.min_price) || (level.level_type.to_sym == :sum_buy && sum >= level.min_price)
                    if level.write_off_rule.to_sym == :write_off_convert && total >= level.write_off_rule_points
                        return level
                    end
                end
            end
        end
        return nil
    end

    def self.write_off_info(order)
        program = order.loyalty_program
        client = order.client
        level = self.find_write_off_level(client, program, order)
        if level
            total = client.valid_points.where('order_id <> ?', order.id).sum(:current_points)
            current_money = ((order.price * level.write_off_rule_percent) / 100.0)
            current_points = [total, (current_money * level.write_off_points / level.write_off_money.to_f)].min
            current_money = current_points * (level.write_off_money / level.write_off_points.to_f)
            return {write_of_money: current_money.to_i, write_off_points: current_points.to_i}
        end
        return {write_of_money: 0, write_off_points: 0}
    end

    def self.write_off(order)
        program = order.loyalty_program
        client = order.client
        if program && order.write_off_status.to_sym == :not_written_off
            level = self.find_write_off_level(client, program, order)
            if level
                points = client.valid_points.where('order_id <> ?', order.id)
                total = points.sum(:current_points)
                current_money = ((order.price * level.write_off_rule_percent) / 100.0)
                current_points = [total, (current_money * level.write_off_points / level.write_off_money.to_f)].min.to_i
                current_money = (current_points * (level.write_off_money / level.write_off_points.to_f)).to_i
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
                order.save
                return true
            end
        end
        return false
    end

    def burn
    end
end