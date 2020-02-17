module Api
  	module V1
   	 	class PromotionsController < ApplicationController
			before_action :auth_create, only: [:create, :index]
			before_action :auth_find, only: [:update, :destroy]
			before_action :set_promotion, only: [:show]

			def index
				render json: @company.promotions
			end

			def show
				render json: @promotion
			end

			def create
				promotion = Promotion.new(promotion_params)
				promotion.company = @company

				if promotion.save
					render json: promotion,  status: :ok
				else
					render json: promotion.errors, status: :unprocessable_entity
				end 
			end

			def update
				if @promotion.update(promotion_params)
					render json: @promotion, loyalty_levels: true, status: :ok
				else
					render json: @promotion.errors, status: :unprocessable_entity
				end
			end

			def destroy
				@promotion.destroy
			end

			private

			def auth
				@auth_user = User.authorize(request.headers['Authorization'])
				@company = Company.find(params[:company_id])
				@auth_user.company_creator?(@company)
			end
			
			def auth_create
				auth
				@auth_user.company_creator?(@company)
			end

			def auth_find
				auth
				set_promotion
				@auth_user.company_creator?(@promotion.company)
			end

			def set_promotion
				@promotion = Promotion.find(params[:id])
			end

			def promotion_params
				params.permit(:name, :begin_date, :end_date, 
					:accrual_rule, :accrual_percent, :accrual_points, :accrual_money,
					:burning_rule, :burning_days, :activation_rule, :activation_days, 
					:write_off_rule, :write_off_rule_percent, :write_off_rule_points, 
					:accordance_rule, :accordance_points, :accordance_percent,
					:accrual_on_points, :rounding_rule,
					:write_off_limited, :write_off_min_price
				)
        	end 
      	end
    end
end
  