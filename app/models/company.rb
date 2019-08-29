class Company < ApplicationRecord
    belongs_to :creator

    has_one :creator
    has_many :operators
    has_many :clients

    validates :creator_id, uniqueness: true
    #TODO: validations

    def ownership(creator)
        if creator != self.creator
            raise ApplicationController::Forbidden
        end
    end
    
end
