
module Api
  module V1
    class ClientsController < ApplicationController

      def create
        @user = Client.new(user_params)
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

      def index
      #   TODO: Как-то сделать вывод по id компании или магаза
      # Или вынести в отдельные методы магазина и/или компании
      end

      def show
        @user = Client.find_by(id:params[:id])
        render json:@user, status: :ok
      end

      private
      
        def auth
          @user = Client.authorize(request.headers['Authorization'])
        end

        def user_params
          params.permit(:email, :password, :password_confirmation)
        end
    end
  end
end