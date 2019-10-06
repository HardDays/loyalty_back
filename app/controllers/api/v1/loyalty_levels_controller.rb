module Api
  module V1
    class LoyaltyLevelsController < ApplicationController
      before_action :auth_create, only: [:create]
      before_action :auth_find, only: [:update, :destroy]

      def create
        @level = LoyaltyLevel.new(level_params)
        @level.loyalty_program = @program

        if @level.save
          render json: @level, loyalty_levels: true, status: :ok
        else
          render json: @level.errors, status: :unprocessable_entity
        end 
      end

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
        end
        
        def auth_creator
          auth
          @auth_user.permission(@auth_user.creator)
        end

        def auth_create
          auth_creator
          @program = LoyaltyProgram.find(params[:loyalty_program_id])
          @program.ownership(@auth_user.creator)
        end

        def auth_find
          auth_creator
          set_level
          @level.loyalty_program.ownership(@auth_user.creator)
        end

        def set_level
          @level = LoyaltyLevel.find(params[:id])
        end

        def level_params
          params.permit(
            :level_type, :type, :min_price, :begin_date, :end_date,
            :accrual_rule, :accrual_percent, :accrual_points, :accrual_money,
            :burning_rule, :burning_days, :activation_rule, :activation_days, 
            :write_off_rule, :write_off_rule_percent, :write_off_rule_points, 
            :write_off_points, :write_off_money,
            :accordance_rule, :accordance_points, :accordance_percent,
            :accrual_on_points, :accrual_on_register, :register_points,
            :accrual_on_first_buy, :first_buy_points, :accrual_on_birthday, :birthday_points,
            :rounding_rule, :sms_on_register, :sms_on_points, :sms_on_write_off, :sms_on_burning, :sms_burning_days
          )
        end
      end
    end
  end
  