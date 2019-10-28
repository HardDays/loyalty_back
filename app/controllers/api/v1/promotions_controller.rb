module Api
  module V1
    class PromotionsController < ApplicationController
      before_action :auth_creator, only: [:index, :create]
      before_action :auth_find, only: [:update, :destroy]
      before_action :set_promotion, only: [:show]

      def index
        @promotions = @auth_user.creator.company.promotions
        render json: @promotions#, loyalty_levels: true
      end

      def show
        render json: @promotion
      end

      def create
        #@level = LoyaltyLevel.new(level_params)
        @promotion = Promotion.new(promotion_params)
        @promotion.company = @auth_user.creator.company
        # @promotion.title = level_params[:title]
        # @promotion.date_to = level_params[:date_to]
        # @promotion.date_from = level_params[:date_from]

        # @level.loyalty_program = @program

        if @promotion.save
          #@level.promotion = @promotion.id
          render json: @promotion,  status: :ok
        else
          render json: @promotion.errors, status: :unprocessable_entity
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
        end
        
        def auth_creator
          auth
          @auth_user.role(@auth_user.creator)
        end

        def auth_find
          auth_creator
          set_promotion
          @auth_user.creator_permission(@promotion)
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
  