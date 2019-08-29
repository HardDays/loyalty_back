
module Api
  module V1
    class CompanyController < ApplicationController
      before_action :auth, only: [:create]
      before_action :auth_creator, only: [:show, :update]

      # def index
      #   @companies = Company.order('created_at DESC')
      #   render json: @companies, status: :ok
      # end

      def show
        render json: @company, status: :ok
      end

      def create
        @company = Company.new(company_params)
        @company.creator = @creator
        #TODO: обсудить
        @creator.company = @company

        if @company.save
           @creator.save
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
          @creator = Creator.authorize(request.headers['Authorization'])
        end

        def set_company
          @company = Company.find(params[:id])
        end

        def auth_creator
          auth
          set_company
          @company.ownership(@creator)
        end

        def company_params
          params.permit(:name, :kpp, :invoice, :inn, :bank, :checking_account, :phone, :web_site, :bic, :legal_entity, :postcode)
        end
    end
  end
end