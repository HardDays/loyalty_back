module Api
    module V1
      class CardsController < ApplicationController
        before_action :auth_operator, only: [:create]
  
        # POST /cards
        def create
          card = Card.new(card_params)
          card.company = @auth_user.operator.company
          if card.save
            render json: card
          else
            render json: card.errors, status: :unprocessable_entity
          end
        end
  
        private
          def auth
            @auth_user = User.authorize(request.headers['Authorization'])
          end
  
          def auth_operator
            auth
            @auth_user.role(@auth_user.operator_role)
          end
  
          def card_params
            params.permit(:number, :points)
          end
      end
    end
  end