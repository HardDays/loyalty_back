
module Api
    module V1
      class OrdersController < ApplicationController
        before_action :auth_create, only: [:create]
        before_action :auth_write_off, only: [:show_write_off, :write_off]
        
        def create
          ActiveRecord::Base.transaction do
            @order = Order.new(order_params)
            @order.operator = @auth_user.operator
            @order.client = @client_user.client
            @order.loyalty_program = @program
            @order.store = @store 
            @order.write_off_status = :not_written_off
            if @order.save
              ClientPointsHelper.create(@client_user.client, @program, @order, params[:use_points])
              render json: @order
            else
              render json: @order.errors, status: :unprocessable_entity
            end
          end
        end

        def show_write_off
          render json: ClientPointsHelper.write_off_info(@order)
        end

        def write_off
          render json: {status: ClientPointsHelper.write_off(@order)}
        end
  
        private
          def auth
            @auth_user = User.authorize(request.headers['Authorization'])
          end
  
          def auth_create
            auth
            set_client
            @auth_user.permission(@auth_user.operator)
            @client_user.operator_check(@auth_user.operator)
            @store = @auth_user.operator.store
          end

          def auth_write_off
            auth
            set_order
            @auth_user.permission(@auth_user.operator)
            @order.ownership(@auth_user.operator)
          end

          def set_order
            @order = Order.find(params[:id])
          end
  
          def set_client
            @client_user = User.find(params[:client_id])
            @program = @client_user.client.loyalty_program
          end
  
          def order_params
            params.permit(:price, :use_points)
          end

      end
    end
  end