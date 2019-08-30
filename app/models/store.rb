class Store < ApplicationRecord

    has_many :operators

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
end
