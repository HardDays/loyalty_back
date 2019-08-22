
module Api
  module V1
    class CompanyInfoController < ApplicationController
      before_action :auth, only: [:create]
      before_action :auth_creator, only: [:update]
      # пока не нужно
      # def index
      #   companys = CompanyInfo.order('created_at DESC')
      #   render json:{status:'SUCCESS', messages:'Companys info list', data:companys}, status: :ok
      # end

      # пока не нужно
      # def show
      #   company = CompanyInfo.find_by(company_id:params[:id])
      #   render json:{status:'SUCCESS', messages:'Company info', data:company}, status: :ok
      # end

      def create
        @company = CompanyInfo.new(company_info_params)
        @company.user = @user
        if @company.save
          # TODO: Make mail and sent it on company email (mail will have any template in app settings)
          # UserMailer.deliver_registration_confirmation(company, @event_message)
           render json: @company, status: :created
        else
           render json: @company.errors, status: :unprocessable_entity
        end
      end
      
      # пока не нужно
      # def destroy
      #   company = CompanyInfo.find(params[:id])
      #   company.destroy
      #   render json:{status:'SUCCESS', messages:'Company removed', data:company}, status: :ok
      # end

      def update
        if @company.update(company_info_params)
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
          @company = @user.company_info
        end

        def company_info_params
          params.permit(:name, :kpp, :invoice, :inn, :bank, :checking_account, :phone, :web_site, :bic, :legal_entity, :postcode)
        end
    end
  end
end