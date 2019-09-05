module Api
  module V1
    class LoyaltyProgramsController < ApplicationController
      before_action :auth_creator, only: [:index, :create]
      before_action :auth_find, only: [:show, :update, :destroy]

      def index
        @programs = @auth_user.creator.company.loyalty_programs.order('created_at DESC')
        render json: @programs
      end

      def show
        render json: @program
      end

      def create
        @program = LoyaltyProgram.new(program_params)
        @program.company = @auth_user.creator.company

        if params[:loyalty_levels]
          params[:loyalty_levels].each do |level|
            @program.loyalty_levels.build(level_params(level))
          end
        end

        if @program.save
          render json: @program, status: :created
        else
          render json: @program.errors, status: :unprocessable_entity
        end
      end

      def update
        if @program.update(program_params)
          render json: @program, status: :ok
        else
          render json: @program.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @program.destroy
      end

      private
        def auth
          @auth_user = User.authorize(request.headers['Authorization'])
        end
        
        def auth_creator
          auth
          @auth_user.permission(@auth_user.creator)
        end

        def auth_find
          auth_creator
          @program = LoyaltyProgram.find(params[:id])
          @program.ownership(@auth_user.creator)
        end

        def program_params
          params.permit(:name)
        end

        def level_params(param)
          param.permit(
            :level_type, :min_price, :begin_date, :end_date, 
            :accrual_rule, :accrual_percent, :accrual_points, :accrual_money,
            :burning_rule, :burning_days, :activation_rule, :activation_days, 
            :write_off_rule, :write_off_percent, :write_off_points, 
            :accordance_rule, :accordance_points, :accordance_percent,
            :accrual_on_points, :accrual_on_register, :register_points,
            :accrual_on_first_buy, :first_buy_points, :accrual_on_birthday, :birthday_points,
            :rounding_rule, :sms_on_register, :sms_on_points, :sms_on_write_off, :sms_on_burning, :sms_burning_days
          )
        end
    end
  end
end
