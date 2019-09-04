class Order < ApplicationRecord

    belongs_to :loyalty_program, optional: true
    belongs_to :client
    belongs_to :store
    belongs_to :operator

    enum write_off_status: [:not_written_off, :written_off]

    validates :price, inclusion: 1..100000000
    validates :use_points, inclusion: {in: [true, false]}
    validates :write_off_status, presence: true

    def ownership(operator)
        if self.operator != operator
            raise ApplicationController::Forbidden
        end
    end


    #TODO: Replace in json client_id etc to actual user_id of this client 
end
