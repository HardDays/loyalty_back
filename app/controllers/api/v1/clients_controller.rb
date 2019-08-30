
module Api
  module V1
    class ClientsController < ApplicationController
      before_action :auth_find, only: [:update]
      before_action :auth_operator, only: [:create]

      def create
        @user = User.new(user_params)
        @user.password = SecureRandom.hex(4)
        if @user.save
          @user.create_user_confirmation(confirm_status: :unconfirmed, code: SecureRandom.hex(2))
          @user.create_client(company: @auth_user.operator.company)
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.operator.errors, status: :unprocessable_entity
        end
      end

      private
        def auth
          @auth_user = User.authorize(request.headers['Authorization'])
        end

        def auth_operator
          auth
          @auth_user.permission(@auth_user.operator)
        end

        def auth_find
          auth_operator
          set_user
          @user.operator_check(@auth_user.operator)
        end

        def user_params
          params.permit(:email, :phone, :first_name, :last_name, :second_name)
        end
    end
  end
end