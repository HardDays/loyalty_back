module Api
  module V1
    class CreatorsController < ApplicationController

      def create
        ActiveRecord::Base.transaction do
          @user = User.new(user_params)
          if @user.save
            @user.create_creator
            @user.create_user_confirmation(confirm_status: :unconfirmed, confirm_hash: SecureRandom.hex)
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
    end
  end
end
