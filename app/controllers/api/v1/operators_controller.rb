
module Api
  module V1
    class OperatorsController < ApplicationController
      before_action :auth_creator, only: [:create, :index]
      before_action :auth_find, only: [:update, :destroy]

      def index
        @operators = @auth_user.creator.company.operators
        if params[:store_id]
          @operators = @operators.where(store_id: params[:store_id])
        end
        render json: @operators.collect{|o| o.user}
      end

      def create
        @user = User.new(user_params)
        # TODO: send to email or phone
        @user.password = SecureRandom.hex(4)
        if @user.save
          @user.create_user_confirmation(confirm_status: :confirmed)
          @user.create_operator(store_id: params[:store_id], company: @auth_user.creator.company)
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(user_params)
          if @user.operator.update(operator_params)
            render json: @user, status: :created
          else 
            render json: @user.errors, status: :unprocessable_entity
          end
        else
          render json: @user.operator.errors, status: :unprocessable_entity
        end
      end

      def destroy
         @user.destroy
      end

      private
        def set_user
          @user = User.find(params[:id])
        end

        def auth
          @auth_user = User.authorize(request.headers['Authorization'])
        end

        def auth_creator
          auth
          @auth_user.permission(@auth_user.creator)
        end

        def auth_find
          auth_creator
          set_user
          @user.creator_check(@auth_user.creator)
        end

        def operator_params
          params.permit(:store_id)
        end

        def user_params
          params.permit(:email, :first_name, :last_name, :second_name)
        end
    end
  end
end