module Api
    module V1
      class CardsController < ApplicationController
        before_action :auth_creator, only: [:create, :create_range]
  
        # POST /cards
        def create
          card = Card.new(card_params)
          card.company = @auth_user.creator.company
          #card.creator = @auth_user.creator
          if card.save
            render json: card
          else
            render json: card.errors, status: :unprocessable_entity
          end
        end

        # POST /cards/range
        def create_range
          if params[:begin_range] && params[:end_range]
            (params[:begin_range].to_i..params[:end_range].to_i).each do |i|
              card = Card.new(card_params)
              card.number = "%010d" % i
              card.company = @auth_user.creator.company
              #card.creator = @auth_user.creator
              card.save
            end
          end
          render status: :ok
        end
  
        private
          def auth
            @auth_user = User.authorize(request.headers['Authorization'])
          end
  
          def auth_creator
            auth
            @auth_user.role(@auth_user.creator_role)
          end
  
          def card_params
            params.permit(:number, :points)
          end
      end
    end
  end