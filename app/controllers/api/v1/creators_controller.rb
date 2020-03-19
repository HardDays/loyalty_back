module Api
  	module V1
    	class CreatorsController < ApplicationController

			before_action :auth, only: [:update_profile]

			# GET /creators
			def show
				render json: {
					status: User.find_by(phone: params[:phone]) != nil
				}
			end

			# POST /creators
			def create
				ActiveRecord::Base.transaction do
					user = User.new(user_params)
					if user.save
						user.create_user_confirmation(confirm_status: :unconfirmed, code: SecureRandom.hex[0..8])
						begin
							ConfirmationMailer.confirmation_email(user).deliver!
						rescue => ex
							puts json: ex
						end
						render json: user, token: true
					else
						render json: user.errors, status: :unprocessable_entity
						raise ActiveRecord::Rollback
					end
				end
			end

			# PUT /creators/profile
			def update_profile
				if params[:password] && !@auth_user.authenticate(params[:current_password]) 
					render status: :forbidden
				else
					if @auth_user.update(user_params)
						render json: @auth_user
					else
						render json: @auth_user.errors, status: :unprocessable_entity
					end
				end
			end

			private

			def auth
				@auth_user = User.authorize(request.headers['Authorization'])
			end
			
			def user_params
				params.permit(:email, :phone, :first_name, :last_name, :second_name, :gender, :birth_day, :password, :password_confirmation)
			end
		end
	end
end
