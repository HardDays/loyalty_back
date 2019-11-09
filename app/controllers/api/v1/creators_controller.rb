module Api
  module V1
    class CreatorsController < ApplicationController

      before_action :auth_creator, only: [:update_profile]

      # GET /creators
      def show
        render json: {
          status: User.find_by(phone: params[:phone]) != nil
        }
      end
      
      # POST /creators
      def create
        ActiveRecord::Base.transaction do
          @user = User.new(user_params)
          if @user.save
            @user.create_creator
            @user.create_user_confirmation(confirm_status: :unconfirmed, code: '0000')
            begin
              ConfirmationMailer.confirmation_email(@user).deliver
            rescue => ex
            end
            render json: @user
          else
            render json: @user.errors, status: :unprocessable_entity
          end
        end
      end

       # PUT /creators/profile
      def update_profile
        @user = @auth_user
        if params[:password] && !@user.authenticate(params[:current_password]) 
          render status: :forbidden
        else
          if @user.update(user_params)
            render json: @user
          else
            render json: @user.errors, status: :unprocessable_entity
          end
        end
      end

      private
        def user_params
          params.permit(:email, :first_name, :last_name, :second_name, :gender, :birth_day, :password, :password_confirmation)
        end

        def auth
          @auth_user = User.authorize(request.headers['Authorization'])
        end

        def auth_creator
          auth
          @auth_user.role(@auth_user.creator_role)
        end
    end
  end
end
