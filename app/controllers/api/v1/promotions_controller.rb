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
        render json: @promotion, loyalty_levels: true
      end

      def create
        #@level = LoyaltyLevel.new(level_params)
        @promotion = Promotion.new(promotion_params)
        @promotion.company = @auth_user.creator.company
        # @promotion.title = level_params[:title]
        # @promotion.date_to = level_params[:date_to]
        # @promotion.date_from = level_params[:date_from]

        # @level.loyalty_program = @program

        if params[:loyalty_levels]
          params[:loyalty_levels].each do |level|
            @promotion.loyalty_levels.build(level_params(level))
          end
        end

        if @promotion.save
          #@level.promotion = @promotion.id
          render json: @promotion, loyalty_levels: true, status: :ok
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

      # def destroy
      #   @level = LoyaltyLevel.find_by(promotion: params[:id])
      #   @promotion.destroy
      # end

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
          set_promotion
          @promotion.ownership(@auth_user.creator)
        end

        def set_promotion
          @promotion = Promotion.find(params[:id])
        end

        def promotion_params
          params.permit(:name, :begin_date, :end_date,)
        end 

        def level_params(param)
          param.permit(
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
  