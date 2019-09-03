
module Api
    module V1
      class OrdersController < ApplicationController
        before_action :auth_operator, only: [:create]
  
        def create
          @order = Order.new(order_params)
          @order.operator = @auth_user.operator
          @order.client = @client_user.client
          @order.loyalty_program = @program
          @order.store = @store

          if @order.save
            if params[:use_points]
            end

            ClientPointsHelper.create(@client_user.client, @program, @order)

            render json: @order
          else
            render json: @order.errors, status: :unprocessable_entity
          end
        end
  
        private
          def auth
            @auth_user = User.authorize(request.headers['Authorization'])
          end
  
          def auth_operator
            auth
            set_client
            set_store
            @auth_user.permission(@auth_user.operator)
            @client_user.operator_check(@auth_user.operator)
          end
  
          def set_client
            @client_user = User.find(params[:client_id])
            @program = @client_user.client.loyalty_program
          end

          def set_store
            @store = Store.find(params[:store_id])
          end
  
          def order_params
            params.permit(:price, :use_points)
          end

      end
    end
  end