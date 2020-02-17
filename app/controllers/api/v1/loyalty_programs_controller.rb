module Api
  	module V1
    	class LoyaltyProgramsController < ApplicationController
			before_action :auth_create, only: [:create, :index]
			before_action :auth_find, only: [:update, :destroy]
			before_action :set_program, only: [:show]

			def index
				render json: @company.loyalty_program, loyalty_levels: true
			end

			def show
				render json: @program, loyalty_levels: true
			end

			def create
				program = LoyaltyProgram.new(program_params)
				program.company = @company

				if params[:loyalty_levels]
					params[:loyalty_levels].each do |level|
						program.loyalty_levels.build(level_params(level))
					end
				end

				if program.save
					render json: program, loyalty_levels: true
				else
					render json: program.errors, status: :unprocessable_entity
				end
			end

			def update
				ActiveRecord::Base.transaction do
					if @program.update(program_params)
						render json: @program, loyalty_levels: true, status: :ok
					else
						render json: @program.errors, status: :unprocessable_entity
					end
				end
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
				set_program
				@auth_user.company_creator?(@program.company)
			end

			def set_program
				@program = LoyaltyProgram.find(params[:id])
			end

			def program_params
				params.permit(:name, :sum_type,
					:write_off_limited, :write_off_min_price,
					:accrual_on_recommend, :recommend_recommendator_points, :recommend_registered_points,
					:accrual_on_register, :register_points,
					:accrual_on_first_buy, :first_buy_points, 
					:accrual_on_birthday, :birthday_points,
					:rounding_rule, 
					:sms_on_register, :sms_on_points, :sms_on_write_off, :sms_on_burning, :sms_burning_days, :sms_on_birthday
				)
			end

			def level_params(param)
				param.permit(
					:name, :min_price, :begin_date, :end_date, 
					:accrual_rule, :accrual_percent, :accrual_points, :accrual_money,
					:burning_rule, :burning_days, :activation_rule, :activation_days, 
					:write_off_rule, :write_off_rule_percent, :write_off_rule_points, 
					:write_off_points, :write_off_money,
					:accordance_rule, :accordance_points, :accordance_percent,
					:accrual_on_points
				)
			end
		end
	end
end
