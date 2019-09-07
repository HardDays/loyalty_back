class Order < ApplicationRecord

    belongs_to :loyalty_program, optional: true
    belongs_to :client
    belongs_to :store
    belongs_to :operator

    has_one :client_point

    enum write_off_status: [:not_written_off, :written_off]

    validates :price, inclusion: 1..100000000
    validates :use_points, inclusion: {in: [true, false]}
    validates :write_off_status, presence: true

    def ownership(operator)
        if self.operator != operator
            raise ApplicationController::Forbidden
        end
    end

    #TODO: think about it
    def as_json(options = {})
        attrs = super.except('client_id')

        attrs[:user_id] = client.user_id
        
        if options[:statistics]
            attrs[:user] = client.user
            attrs[:store] = store.as_json(only: [:id, :name])
            attrs[:loyalty_program] = loyalty_program.as_json(only: [:id, :name])            
        end

        return attrs
    end
end
