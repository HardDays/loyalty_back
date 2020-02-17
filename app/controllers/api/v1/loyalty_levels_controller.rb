module Api
  	module V1
    	class LoyaltyLevelsController < ApplicationController
			before_action :auth_create, only: [:create]
			before_action :auth_find, only: [:show, :update, :destroy]

			# GET /loyalty_levels/:id
			def show
				render json: @level
			end

			# POST /loyalty_levels
			def create
				level = LoyaltyLevel.new(level_params)
				level.loyalty_program = @program

				if level.save
					render json: level, loyalty_levels: true, status: :ok
				else
					render json: level.errors, status: :unprocessable_entity
				end 
			end

			# PUT /loyalty_levels/:id
			def update
				if @level.update(level_params)
					render json: @level, loyalty_levels: true, status: :ok
				else
					render json: @level.errors, status: :unprocessable_entity
				end
			end

			def destroy
				@level.destroy
			end

			private
			
			def auth
				@auth_user = User.authorize(request.headers['Authorization'])
				@company = Company.find(params[:company_id])
				@auth_user.company_creator?(@company)
			end
			
			def auth_create
				auth
				@program = LoyaltyProgram.find(params[:loyalty_program_id])
				@auth_user.company_creator?(@program.company)
			end

			def auth_find
				auth
				@level = LoyaltyLevel.find(params[:id])
				@auth_user.company_creator?(@level.loyalty_program.company)
			end

			def level_params
				params.permit(
					:name, :min_price, :begin_date, :end_date, 
					:accrual_rule, :accrual_percent, :accrual_points, :accrual_money,
					:burning_rule, :burning_days, :activation_rule, :activation_days, 
					:write_off_rule, :write_off_rule_percent, :write_off_rule_points, 
					:write_off_points, :write_off_money,
					:accordance_rule, :accordance_points, :accordance_percent,
					:accrual_on_points,
				)
			end
      	end
    end
end
  