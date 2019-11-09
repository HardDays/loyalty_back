module Api
  module V1
    class CompaniesController < ApplicationController
      before_action :auth_creator, only: [:show, :create, :update]

      def show
        render json: @company, tariff_plan: true, status: :ok
      end

      def create
        ActiveRecord::Base.transaction do
          @company = Company.new(company_params)
          @company.creator = @auth_user.creator
          #@tariff_plan = TariffPlan.where(tariff_type: :demo).first
          #@company.create_tariff_plan_purchase(tariff_plan_id: @tariff_plan.id, expired_at: DateTime.now + @tariff_plan.days.days)
          
          if @company.save
            render json: @company
          else
            puts json: @company.errors
            render json: @company.errors, status: :unprocessable_entity
          end
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
          @auth_user = User.authorize(request.headers['Authorization'])
        end

        def auth_creator
          auth
          @auth_user.role(@auth_user.creator_role)
          @company = @auth_user.creator.company
        end

        def company_params
          params.permit(:name)
        end
    end
  end
end