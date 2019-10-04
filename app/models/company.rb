class Company < ApplicationRecord
    belongs_to :creator

    has_many :operators
    has_many :clients
    has_many :stores
    has_one :loyalty_programs

    validates :creator_id, uniqueness: true
    
    validates :name, length: {minimum: 1, maximum: 128}

    def ownership(creator)
        if creator != self.creator
            raise ApplicationController::Forbidden
        end
    end

    #TODO: Replace in json creator_id etc to actual user_id of this creator 

end
