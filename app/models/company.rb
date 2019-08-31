class Company < ApplicationRecord
    belongs_to :creator

    has_many :operators
    has_many :clients
    has_many :stores
    has_many :loyalty_programs

    validates :creator_id, uniqueness: true
    
    validates :name, length: {minimum: 1, maximum: 128}

    def ownership(creator)
        if creator != self.creator
            raise ApplicationController::Forbidden
        end
    end
    
end
