
module Api
  module V1
    class UsersController < ApplicationController
      before_action :auth, only: [:update]
      # пока не нужно
      # def index
      #   companys = User.order('created_at DESC')
      #   render json:{status:'SUCCESS', messages:'User list', data:companys}, status: :ok
      # end

      # пока не нужно
      # def show
      #   User = User.find(params[:id])
      #   render json:{status:'SUCCESS', messages:'User list', data:User}, status: :ok
      # end

      def create
        @user = User.new(user_params)
        # операторов только создатель может создавать
        @user.user_type = :creator
        
        # проверка в модели
        # if user_params[:password] != user_params[:password_confirm]
        #   render json:{status:'ERROR', messages:'Passwords do not match', data:[]}, status: :unprocessable_entity
        # else
        
        if @user.save
          # создание has_one ассоциации, тоже магия рельс
          @user.create_user_confirmation(confirm_status: :unconfirmed, confirm_hash: SecureRandom.hex)

          # TODO: Make mail and sent it on User email (mail will have any template in app settings)
          # отправить @user.user_confirmation.hash
          # UserMailer.deliver_registration_confirmation(User, @event_message)

          # статус уже есть в ответе статус кода
          # render json:{status:'SUCCESS', messages:'User created', data:user_params}, status: :created
          render json: @user, status: :created
        else
          # используем стандартные ошибки
          #render json:{status:'ERROR', messages:'User failed when creating', data:User.errors}, status: :unprocessable_entity
          render json: @user.errors, status: :unprocessable_entity
        end
        
      end

      # пока не нужно
      # def destroy
      #   User = User.find(params[:id])
      #   company_info = Company.find_by(company_id:params[:id])
      #   if company_info
      #     company_info.destroy
      #   end
      #   User.destroy

      #   render json:{status:'SUCCESS', messages:'User removed', data:User}, status: :ok
      # end

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
          @user = User.authorize(request.headers['Authorization'])
        end

        def user_params
          params.permit(:email, :password, :password_confirmation)
        end
    end
  end
end