class Company < ApplicationRecord
    belongs_to :user

    validates :user_id, uniqueness: true
    #TODO: validations

    def authenticate(user)
        if user != self.user
            raise ApplicationController::Forbidden
        end
    end
end
