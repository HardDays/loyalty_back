module Api
  	module V1
    	class OrdersController < ApplicationController
			before_action :auth_program, only: [:create_program_order, :show_program_points]
			before_action :auth_promotion, only: [:create_promotion_order, :show_promotion_points]

			# GET /orders/loyalty_program/points
			def show_program_points
				render json: ClientPointsHelper.points_info_program(@user.client(@company), params[:price].to_i)
			end

			# GET /orders/promotion/points
			def show_promotion_points
				render json: ClientPointsHelper.points_info_promotion(@user.client(@company), params[:price].to_i, @promotion)
			end

			# POST /orders/program
			def create_program_order
				ActiveRecord::Base.transaction do
					create
					create_first_points

					client = @user.client(@company)

					@order.loyalty_program = client.loyalty_program

					if @order.save
						ClientPointsHelper.create_from_program(client, @order, client.loyalty_program, params[:write_off_points])
						render json: @order
					else
						render json: @order.errors, status: :unprocessable_entity
					end
				end
			end

			#POST /orders/promotion
			def create_promotion_order
				ActiveRecord::Base.transaction do
					create
					create_first_points
					
					@order.promotion = @promotion
					
					if @order.save
						ClientPointsHelper.create_from_promotion(@user.client(@company), @order, @promotion, params[:write_off_points])
						render json: @order
					else
						render json: @order.errors, status: :unprocessable_entity
					end
				end
			end

			private

			def create
				@order = Order.new(order_params)
				@order.operator = @auth_user.operator(@company)
				@order.client = @user.client(@company)
				@order.store = @auth_user.operator(@company).store
				@order.write_off_status = :not_written_off
			end

			def create_first_points
				client = @user.client(@company)
				program = client.loyalty_program
				if program.accrual_on_first_buy && client.orders.count == 0
					first = ClientPoint.new(
						current_points: program.first_buy_points,
						initial_points: program.first_buy_points,
						burning_date: DateTime.now + 100.years,
						activation_date: DateTime.now,
						client: client,
						loyalty_program: program,
						points_source: :first_buy
					)
					first.save
				end
			end

			def auth
				@user = User.find(params[:user_id])
				@company = Company.find(params[:company_id])
				if params[:service_token]
					@company.valid_token?(params[:service_token])
				else
					@auth_user = User.authorize(request.headers['Authorization'])
					@auth_user.company_operator?(@company)
				end
				@user.company_client?(@company)
			end

			def auth_program
				auth
			end

			def auth_promotion
				auth
				@promotion = Promotion.find_by(id: params[:promotion_id], company_id: params[:company_id])
			end

			def order_params
				params.permit(:price)
			end
    	end
  	end
end