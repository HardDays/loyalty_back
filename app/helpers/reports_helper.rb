class ReportsHelper

    def self.filter_date(collection, field, begin_date, end_date)
        if begin_date
            collection = collection.where("#{field} > ?", begin_date)
        end
        if end_date
            collection = collection.where("#{field} <= ?", end_date)
        end
        return collection
    end

    def self.general(company, begin_date, end_date, stores, loyalty_programs, operators)
        #TODO: filter sotres, programs, operators

        clients = Client.where(company_id: company.id)
        clients_count = filter_date(clients, 'created_at', begin_date, end_date).count
        
        points = ClientPoint.joins(:client).where(client: clients)

        accrued_points = filter_date(points, 'created_at', begin_date, end_date)
        accrued_points = accrued_points.sum(:initial_points)

        current_points = filter_date(points, 'updated_at', begin_date, end_date)
        current_points = current_points.sum(:current_points)

        written_off_points = accrued_points - current_points

        orders = Order.joins(:client).where(client: clients)
        orders = filter_date(orders, 'created_at', begin_date, end_date)
        customers_count = orders.group(:client_id).distinct.count(:client_id).length

        total_price = orders.sum(:price)

        average_price = orders.average(:price).to_i

        repeat_customers_count = orders.group(:client_id).having('count(client_id) > 1').count(:client_id).length
        
        repeat_total_price = orders.group(:client_id).having('count(client_id) > 1').sum(:price).sum{|k, v| v}

        repeat_average_price = orders.group(:client_id).having('count(client_id) > 1').average(:price).values
        repeat_average_price = (repeat_average_price.reduce(:+) / repeat_average_price.length).to_i

        birthdays_count = filter_date(points, 'created_at', begin_date, end_date)
        birthdays_count = birthdays_count.where(points_source: :birthday).count

        birthday_points = filter_date(points, 'created_at', begin_date, end_date)
        birthday_points =  birthday_points.where(points_source: :birthday).sum(:initial_points)

        used_clients_count = filter_date(points, 'updated_at', begin_date, end_date).where('initial_points <> current_points')
        used_clients_count = used_clients_count.group(:client_id).distinct.count(:client_id).length

        used_total_price = filter_date(points, 'created_at', begin_date, end_date).joins(:order)
        used_total_price = used_total_price.group(:order_id).sum(:price).sum{|k, v| v}
        
        used_average_price = filter_date(points, 'created_at', begin_date, end_date).joins(:order)
        used_average_price = used_average_price.group(:order_id).average(:price).values
        used_average_price = (used_average_price.reduce(:+) / used_average_price.length).to_i

        unactive_clients_count = orders.group(:client_id).having('count(client_id) = 0').count(:client_id).length
        
        #TODO: dopilt
        #unactive_clients_points = orders.group(:client_id).having('count(client_id) = 0').joins(:clients_points).sum(:points)

        return {
            clients_count: clients_count,
            current_points: current_points,
            accrued_points: accrued_points,
            written_off_points: written_off_points,
            customers_count: customers_count,
            total_price: total_price,
            average_price: average_price,
            repeat_customers_count: repeat_customers_count,
            repeat_total_price: repeat_total_price,
            repeat_average_price: repeat_average_price,
            birthdays_count: birthdays_count,
            birthday_points: birthday_points,
            used_clients_count: used_clients_count,
            used_total_price: used_total_price,
            used_average_price: used_average_price,
            unactive_clients_count: unactive_clients_count

        }
    end

end