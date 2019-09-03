class ClientPointsHelper

    def self.create(client, program, order)
        if program
            sum = client.orders.sum{|o| o.price} + order.price
            program.loyalty_levels.order(min_price: :desc).each do |level|
                if DateTime.now > level.begin_date && DateTime.now < level.end_date
                    if (level.level_type.to_sym == :one_buy && order.price >= level.min_price) || (level.level_type.to_sym == :sum_buy && sum >= level.min_price)
                        points = 0
                        if level.accrual_rule.to_sym == :accrual_percent
                            points = (order.price * level.accrual_percent) / 100
                        elsif level.accrual_rule.to_sym == :accrual_convert
                            points = order.price * (accrual_points / accrual_money)
                        end

                        activation_date = DateTime.now
                        if level.activation_rule.to_sym == :activation_days
                            activation_date += level.activation_days.days
                        end

                        burning_date = DateTime.now + 100.years
                        if level.burning_rule.to_sym == :burning_days
                            burning_date = DateTime.now + level.burning_days.days
                        end

                        points = points.to_i
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
                        
                        client_points = ClientPoints.new(
                            points: points,
                            burning_date: burning_date,
                            activation_date: activation_date,
                            client: client,
                            order: order,
                            loyalty_program: program
                        )
                        client_points.save
                    end
                end
            end
        end

    end

    def self.use_points(client, program, order)
        #TODO: dopilit
    end

end