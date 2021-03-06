module Api
  module V1
    class OrdersController < ApplicationController
      before_action :auth_program, only: [:create_program_order, :show_program_points]
      before_action :auth_promotion, only: [:create_promotion_order, :show_promotion_points]

      before_action :auth, only: [:show_points]

      # GET /orders/loyalty_program/points
      def show_program_points
        render json: ClientPointsHelper.points_info_program(@user.client, params[:price].to_i)
      end

      # GET /orders/promotion/points
      def show_promotion_points
        render json: ClientPointsHelper.points_info_promotion(@user.client, params[:price].to_i, @promotion)
      end

      # POST /orders/program
      def create_program_order
        ActiveRecord::Base.transaction do
          create
          create_first_points

          @order.loyalty_program = @user.client.loyalty_program

          if @order.save
            ClientPointsHelper.create_from_program(@user.client, @order, @user.client.loyalty_program, params[:write_off_points])
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
            ClientPointsHelper.create_from_promotion(@user.client, @order, @promotion, params[:write_off_points])
            render json: @order
          else
            render json: @order.errors, status: :unprocessable_entity
          end
        end
      end

      private

        def create
          @order = Order.new(order_params)
          @order.operator = @auth_user.operator
          @order.client = @user.client
          @order.store = @auth_user.operator.store
          @order.write_off_status = :not_written_off
        end

        def create_first_points
          program = @user.client.loyalty_program
          if program.accrual_on_first_buy && @user.client.orders.count == 0
            first = ClientPoint.new(
                current_points: program.first_buy_points,
                initial_points: program.first_buy_points,
                burning_date: DateTime.now + 100.years,
                activation_date: DateTime.now,
                client: @user.client,
                loyalty_program: program,
                points_source: :first_buy
            )
            first.save
          end
        end

        def auth
          @auth_user = User.authorize(request.headers['Authorization'])
          set_client
          @auth_user.role(@auth_user.operator_role)
          @auth_user.permission(@auth_user.operator, @user.client)
        end

        def auth_program
          auth
        end

        def auth_promotion
          auth
          set_promotion
          @auth_user.permission(@auth_user.operator, @promotion)
        end

        def set_client
          @user = User.find(params[:user_id])
        end

        def set_promotion
          @promotion = Promotion.find(params[:promotion_id])
        end

        def order_params
          params.permit(:price)
        end
    end
  end
end