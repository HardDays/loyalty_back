
module Api
  module V1
    class UsersController < ApplicationController
      before_action :auth, only: [:update]
      def create
        @user = User.new(user_params)
        @user.user_type = :creator

        if @user.save
          @user.create_user_confirmation(confirm_status: :unconfirmed, confirm_hash: SecureRandom.hex)

          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
        
      end

      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      private
      
        def auth
          @user = User.authorize(request.headers['Authorization'])
        end

        def user_params
          params.permit(:email, :phone, :first_name, :last_name, :password, :password_confirmation)
        end
    end
  end
end