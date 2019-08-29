
module Api
  module V1
    class CreatorsController < ApplicationController
      before_action :auth, only: [:update]

      def create
        @user = Creator.new(user_params)
        if @user.save
          # создание has_one ассоциации, тоже магия рельс
          @user.create_user_confirmation(confirm_status: :unconfirmed, confirm_hash: SecureRandom.hex)

          render json: @user, status: :created
        else
          # используем стандартные ошибки
          render json: @user.errors, status: :unprocessable_entity
        end
        
      end

      # аналогично create
      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      private
      
        def auth
          @user = Creator.authorize(request.headers['Authorization'])
        end

        def user_params
          params.permit(:email, :password, :password_confirmation)
        end
    end
  end
end