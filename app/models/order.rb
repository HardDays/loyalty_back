class Order < ApplicationRecord

    belongs_to :client
    belongs_to :store
    belongs_to :operator
    belongs_to :loyalty_program, optional: true
    belongs_to :promotion, optional: true

    has_one :client_point

    enum write_off_status: [:not_written_off, :written_off]

    validates :price, inclusion: 1..100000000
    validates :write_off_points, inclusion: 1..100000000, allow_nil: true

    def ownership(operator)
        if self.operator != operator
            raise ApplicationController::Forbidden
        end
    end

    #TODO: think about it
    def as_json(options = {})
        attrs = super.except('client_id')

        attrs[:client_id] = client.user_id
        attrs[:operator_id] = operator.user_id

        if options
            if options[:client]
                attrs[:client] = client.user    
            end
            if options[:operator]
                attrs[:operator] = operator.user
            end
            if options[:store] && store
                attrs[:store] = store.as_json(only: [:id, :name])
            end
            if options[:loyalty_program] && loyalty_program
                attrs[:loyalty_program] = loyalty_program.as_json(only: [:id, :name])            
            end
            if options[:promotion] && promotion
                attrs[:promotion] = promotion.as_json(only: [:id, :name])            
            end
            if options[:client_point] && client_point
                attrs[:points] = client_point.initial_points
            end
        end

        return attrs
    end
end
