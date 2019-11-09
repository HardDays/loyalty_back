module Api
  module V1
    class TariffPlansController < ApplicationController
      before_action :set_tariff_plan, only: [:purchase]
      before_action :auth_creator, only: [:purchase]

      def index
        @tariff_plans = TariffPlan.where(tariff_type: :paid)
        render json: @tariff_plans
      end

      def purchase
        @company = @auth_user.creator.company
        if @tariff_plan.tariff_type.to_sym != :demo
          current_plan = @company.tariff_plan_purchase
          if current_plan.tariff_plan.tariff_type.to_sym == :demo || current_plan.expired_at > (DateTime.now - 3.days)
            @company.create_tariff_plan_purchase(tariff_plan_id: @tariff_plan.id, expired_at: DateTime.now + @tariff_plan.days.days)
            @company.save
            render status: :ok
          else
            render status: :unprocessable_entity
          end
        else
          render status: :not_found
        end
      end

      private
        def set_tariff_plan
          @tariff_plan = TariffPlan.find(params[:tariff_plan_id])
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