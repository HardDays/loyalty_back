class Store < ApplicationRecord

    has_many :operators, dependent: :nullify
    has_many :orders, dependent: :nullify

    belongs_to :company

    validates :name, length: {minimum: 1, maximum: 128}
    validates :city, length: {minimum: 1, maximum: 64}
    validates :country, length: {minimum: 1, maximum: 64}
    validates :street, length: {minimum: 1, maximum: 128}
    validates :house, length: {minimum: 1, maximum: 16}

    def ownership(creator)
        if creator.company != self.company
            raise ApplicationController::Forbidden
        end
    end

    

    #TODO: Replace in json client_id etc to actual user_id of this client  
end
