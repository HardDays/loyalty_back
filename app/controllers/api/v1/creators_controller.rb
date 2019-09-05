module Api
  module V1
    class CreatorsController < ApplicationController

      def create
        @user = User.new(user_params)
        if @user.save
          @user.create_creator
          @user.create_user_confirmation(confirm_status: :unconfirmed, confirm_hash: SecureRandom.hex)
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      private
        def user_params
          params.permit(:email, :first_name, :last_name, :second_name, :password, :password_confirmation)
        end
    end
  end
end
