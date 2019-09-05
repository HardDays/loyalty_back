module Api
  module V1
    class CompaniesController < ApplicationController
      before_action :auth_creator, only: [:show, :create, :update]

      def show
        render json: @company, status: :ok
      end

      def create
        @company = Company.new(company_params)
        @company.creator = @user.creator
        if @company.save
          render json: @company, status: :created
        else
          render json: @company.errors, status: :unprocessable_entity
        end
      end

      def update
        if @company.update(company_params)
          render json: @company
        else
          render json: @company.errors, status: :unprocessable_entity
        end
      end

      private
        def auth
          @user = User.authorize(request.headers['Authorization'])
        end

        def auth_creator
          auth
          @user.permission(@user.creator)
          @company = @user.creator.company
        end

        def company_params
          params.permit(:name)
        end
    end
  end
end