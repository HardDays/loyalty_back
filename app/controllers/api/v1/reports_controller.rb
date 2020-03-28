module Api
  	module V1
      	class ReportsController < ApplicationController
			before_action :auth, only: [:general, :clients, :orders, :sms]
	
			def general
				render json: ReportsHelper.general(
					@company,
					params[:begin_date], 
					params[:end_date], 
					params[:stores], 
					params[:loyalty_programs],
					params[:promotions],
					params[:operators]
				)
			end

			def clients
				render json: ReportsHelper.clients(
					@company,
					params[:begin_date], 
					params[:end_date], 
					params[:stores], 
					params[:loyalty_programs],
					params[:promotions],
					params[:operators],
					params[:limit],
					params[:offset]
				)
			end

			def orders
				render json: ReportsHelper.orders(
					@company,
					params[:begin_date], 
					params[:end_date], 
					params[:stores], 
					params[:loyalty_programs],
					params[:promotions],
					params[:operators],
					params[:limit],
					params[:offset]
				), client: true, operator: true, store: true, loyalty_program: true, promotion: true, client_point: true
			end

			def sms
				render json: ReportsHelper.sms(
					@company,
					params[:begin_date], 
					params[:end_date], 
					params[:stores], 
					params[:loyalty_programs],
					params[:promotions],
					params[:operators]
				)
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