module Api
  	module V1
    	class CardsController < ApplicationController
			before_action :auth, only: [:create, :create_range]

			# POST /cards
			def create
				card = Card.new(card_params)
				card.company = @company
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
						card.company = @company
						#card.creator = @auth_user.creator
						card.save
					end
				end
				render status: :ok
			end

			private
			
			def auth
				@auth_user = User.authorize(request.headers['Authorization'])
				@company = Company.find(params[:company_id])
				@auth_user.company_operator?(@company)
			end

			def card_params
				params.permit(:number, :points)
			end
		end
	end
end