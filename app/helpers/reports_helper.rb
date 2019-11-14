module ReportsHelper

    def self.filter_date(collection, field, begin_date, end_date)
        if begin_date
            collection = collection.where("#{field} > ?", begin_date)
        end
        if end_date
            collection = collection.where("#{field} <= ?", end_date)
        end
        return collection
    end

    def self.filter_stores(collection, stores)
        if stores
            collection = collection.where(orders: {store_id: stores})
        end
        return collection
    end

    def self.filter_programs(collection, programs)
        if programs
            collection = collection.where(clients: {loyalty_program_id: programs})
        end
        return collection
    end

    def self.filter_promotions(collection, promotions)
        if promotions
            collection = collection.where(clients: {promotion_id: promotions})
        end
        return collection
    end

    def self.filter_operators(collection, operators)
        if operators
            collection = collection.where(orders: {operator_id: operators})
        end
        return collection
    end

    def self.general(company, begin_date, end_date, stores, loyalty_programs, promotions, operators)
        clients = Client.where(company_id: company.id)
        #clients = filter_programs(clients, loyalty_programs)

        clients_count = filter_date(clients, 'created_at', begin_date, end_date).count
        
        orders = Order.joins(:client).where(client: clients)
        orders = filter_operators(orders, operators)
        orders = filter_stores(orders, stores)
        orders = filter_promotions(orders, promotions)
        orders = filter_programs(orders, loyalty_programs)
        orders_date = filter_date(orders, 'orders.created_at', begin_date, end_date)

        orders_count = orders_date.count

        cards_count = orders_date.where('clients.card_number <> null').select('clients.card_number').uniq.count

        average_price = orders_date.average(:price).to_i

        points = ClientPoint.joins(:client).where(client: clients)
        points = points.joins(:order).where(order: orders)

        accrued_points = filter_date(points, 'client_points.created_at', begin_date, end_date).sum(:initial_points)
        current_points = filter_date(points, 'client_points.updated_at', begin_date, end_date).sum(:current_points)
        
        written_off_points = accrued_points - current_points

        # accrued_points = filter_date(points, 'client_points.created_at', begin_date, end_date)
        # accrued_points = accrued_points.sum(:initial_points)

        # current_points = filter_date(points, 'client_points.updated_at', begin_date, end_date)
        # current_points = current_points.sum(:current_points)

        # written_off_points = accrued_points - current_points

        # orders = Order.joins(:client).where(client: clients)
        # orders = filter_operators(orders, operators)
        # orders = filter_stores(orders, stores)
        # orders = filter_date(orders, 'orders.created_at', begin_date, end_date)
        # active_clients_count = orders.group(:client_id).distinct.count(:client_id).length

        # active_total_price = orders.sum(:price)

        # active_average_price = orders.average(:price).to_i

        # repeat_clients = orders.group('clients.id').having('count(orders.id) > 1')

        # repeat_clients_count = repeat_clients.count('orders.id').length
        
        # repeat_total_price = repeat_clients.sum(:price).sum{|k, v| v}

        # repeat_average_price = repeat_clients.average(:price).values
        # repeat_average_price = (repeat_average_price.reduce(:+) || 0 / [repeat_average_price.length, 1].max).to_i

        # birthdays_count = filter_date(points, 'client_points.created_at', begin_date, end_date)
        # birthdays_count = birthdays_count.where(points_source: :birthday).count

        # birthday_points = filter_date(points, 'client_points.created_at', begin_date, end_date)
        # birthday_points =  birthday_points.where(points_source: :birthday).sum(:initial_points)

        # used_clients = filter_date(points, 'client_points.updated_at', begin_date, end_date).where('initial_points <> current_points')

        # used_clients_count = used_clients.group(:client_id).distinct.count(:client_id).length

        # used_total_price = used_clients.joins(:order).group(:order_id).sum(:price).sum{|k, v| v}
        
        # used_average_price = used_clients.joins(:order).group(:client_id).sum(:price).values
        # used_average_price = (used_average_price.reduce(:+) || 0 / [used_average_price.length, 1].max).to_i

        # unactive_clients = clients.includes(:orders)
        # unactive_clients = filter_stores(unactive_clients, stores)
        # unactive_clients = filter_operators(unactive_clients, operators)
        # unactive_clients = filter_date(unactive_clients, 'orders.created_at', begin_date, end_date)
        # unactive_clients = unactive_clients.group('clients.id').having('count(orders.id) = 0').count('orders.id')
        
        # unactive_clients_count = unactive_clients.length
        
        # unactive_clients_points = unactive_clients.collect{|k, v| k}
        # unactive_clients_points = points.where(client_id: unactive_clients_points).sum(:current_points)

        return {
            clients_count: clients_count,
            orders_count: orders_count,
            cards_count: cards_count,
            average_price: average_price,
            accrued_points: accrued_points,
            written_off_points: written_off_points,
            #current_points: current_points,
            # accrued_points: accrued_points,
            # written_off_points: written_off_points,
            #active_clients_count: active_clients_count,
            #active_total_price: active_total_price,
            #active_average_price: active_average_price,
            # repeat_clients_count: repeat_clients_count,
            # repeat_total_price: repeat_total_price,
            # repeat_average_price: repeat_average_price,
            # birthdays_count: birthdays_count,
            # birthday_points: birthday_points,
            # used_clients_count: used_clients_count,
            # used_total_price: used_total_price,
            # used_average_price: used_average_price,
            # unactive_clients_count: unactive_clients_count,
            # unactive_clients_points: unactive_clients_points
        }
    end

    def self.clients(company, begin_date, end_date, stores, loyalty_programs, promotions, operators, limit, offset)
        clients = Client.where(company_id: company.id)

        orders = Order.joins(:client).where(client_id: clients)
        orders = filter_promotions(orders, promotions)
        orders = filter_programs(orders, loyalty_programs)
        orders = filter_operators(orders, operators)
        orders = filter_stores(orders, stores)
        orders = filter_date(orders, 'orders.created_at', begin_date, end_date)

        active_clients = clients.joins(:orders).where(id: clients).limit(limit).offset(offset)

        return User.where(id: active_clients.pluck(:user_id).uniq)
    end

    def self.orders(company, begin_date, end_date, stores, loyalty_programs, promotions, operators, limit, offset)
        clients = Client.where(company_id: company.id)

        orders = Order.joins(:client).where(client_id: clients)
        orders = filter_promotions(orders, promotions)
        orders = filter_programs(orders, loyalty_programs)
        orders = filter_operators(orders, operators)
        orders = filter_stores(orders, stores)
        orders = filter_date(orders, 'orders.created_at', begin_date, end_date).limit(limit).offset(offset)
        
        return orders.includes(:client)
    end

    def self.sms(company, begin_date, end_date, stores, loyalty_programs, promotions, operators)
        sms = ClientSms.joins(:client).where('clients.company_id = ?', company.id)
        sms = filter_date(sms, 'created_at', begin_date, end_date)
        
        total_count = sms.length
        points_accrued_count = sms.where(sms_type: :points_accrued).length
        points_written_off_count = sms.where(sms_type: :points_writen_off).length
        points_burned_count = sms.where(sms_type: :points_burned).length
        registered_count = sms.where(sms_type: :registered).length
        recommend_count = sms.where(sms_type: :recommend).length

        return {
            total_count: total_count,
            points_accrued_count: points_accrued_count,
            points_written_off_count: points_written_off_count,
            points_burned_count: points_burned_count,
            registered_count: registered_count,
            recommend_count: recommend_count
        }
    end

end