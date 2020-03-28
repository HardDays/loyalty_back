module Api
  	module V1
    	class SmsController < ApplicationController
			before_action :auth, only: [:create]

			# POST /sms
			def create
				if params[:message] && params[:message].length > 0
					clients = @company.clients
					if params[:loyalty_program_id]
						clients = clients.where(loyalty_program_id: params[:loyalty_program_id]).includes(:user)
					end
					clients.each do |c|
						SmsHelper.send(c.user.phone, params[:message])
					end
				end
				render status: :ok
			end

			private
			
			def auth
				@auth_user = User.authorize(request.headers['Authorization'])
				@company = Company.find(params[:company_id])
				@auth_user.company_creator?(@company)
			end
		end
  	end
end