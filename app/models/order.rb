class Order < ApplicationRecord

    belongs_to :loyalty_program, optional: true
    belongs_to :client
    belongs_to :store
    belongs_to :operator

    validates :price, inclusion: 1..100000000
    validates :use_points, inclusion: {in: [true, false]}


    #TODO: Replace in json client_id etc to actual user_id of this client 
end
