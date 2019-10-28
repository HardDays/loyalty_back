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
        render json: @operators.limit(params[:limit]).offset(params[:offset]).collect{|o| o.user}
      end

      def create
        ActiveRecord::Base.transaction do
          @user = User.new(user_params)
          # TODO: send to email or phone
          @user.password = '1234567' #SecureRandom.hex(4)
          if @user.save
            @user.create_user_confirmation(confirm_status: :confirmed)
            @user.create_operator(store_id: params[:store_id], company: @auth_user.creator.company, operator_status: :active)
            render json: @user
          else
            render json: @user.errors, status: :unprocessable_entity
          end
        end
      end

      def update
        ActiveRecord::Base.transaction do
          if @user.update(user_params)
            if @user.operator.update(operator_params)
              render json: @user
            else 
              render json: @user.errors, status: :unprocessable_entity
            end
          else
            render json: @user.operator.errors, status: :unprocessable_entity
          end
        end
      end

      def destroy
         @user.operator.operator_status = :deleted
         if @user.operator.save
          render json: @user
        else 
          render json: @user.errors, status: :unprocessable_entity
        end
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
          @auth_user.role(@auth_user.creator)
        end

        def auth_find
          auth_creator
          set_user
          @auth_user.creator_permission(@user.operator)
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