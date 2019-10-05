module Api
  module V1
    class LoyaltyPromotionController < ApplicationController
      before_action :auth_create, only: [:create]
      before_action :auth_find, only: [:update, :destroy]

      def create
        @level = LoyaltyLevel.new(level_params)
        @promotion = Promotion.new(level_params)

        @promotion.title = level_params[:title]
        @promotion.date_to = level_params[:date_to]
        @promotion.date_from = level_params[:date_from]

        @level.loyalty_program = @program

        if @promotion.save
          @level.promotion = @promotion.id
          if @level.save
            render json: @promotion, loyalty_levels: true, status: :ok
          else
            render json: @level.errors, status: :unprocessable_entity
          end
        else
          render json: @promotion.errors, status: :unprocessable_entity
        end 
      end

      def update
        if @promotion.update(level_params)
          if @level.update(level_params)
            render json: @promotion, loyalty_levels: true, status: :ok
          else
            render json: @level.errors, status: :unprocessable_entity
          end
        else
          render json: @promotion.errors, status: :unprocessable_entity
        end
      end

      # Надо как-то соотносить с программой лояльности. Пока оставлю так
      def list
        @promotion = Promotion.all()
      end

      def destroy
        @level = LoyaltyLevel.find_by(promotion: params[:id])
        @promotion.destroy
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
          @level = LoyaltyLevel.find_by(promotion: params[:id])
        end

        def level_params
          params.permit(
            :title,  :date_from, :date_to,
            :level_type, :min_price,:accrual_rule, :accrual_percent, :accrual_points, :accrual_money,
            :burning_rule, :burning_days, :activation_rule, :activation_days, 
            :write_off_rule, :write_off_rule_percent, :write_off_rule_points, 
            :write_off_points, :write_off_money,
            :accordance_rule, :accordance_points, :accordance_percent,
            :accrual_on_points, :accrual_on_register, :register_points,
            :accrual_on_first_buy, :first_buy_points, :accrual_on_birthday, :birthday_points,
            :rounding_rule
          )
        end
      end
    end
  end
  