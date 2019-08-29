
module Api
  module V1
    class ClientsController < ApplicationController
      before_action :auth_operator, only: [:create]

      def index
        #   TODO: Как-то сделать вывод по id компании или магаза
        # Или вынести в отдельные методы магазина и/или компании
      end

      def show
        @client = Client.find_by(id:params[:id])
        render json:@client, status: :ok
      end

      def create
        @client = Client.new(client_params)
        @client.company = @operator.company

        if @client.save
          render json: @client, status: :created
        else
          render json: @client.errors, status: :unprocessable_entity
        end
      end

      def update
        if @client.update(client_params)
          render json: @client
        else
          render json: @client.errors, status: :unprocessable_entity
        end
      end

      private
        def auth_client
          @client = Client.authorize(request.headers['Authorization'])
        end

        def auth_operator
          @operator = Operator.authorize(request.headers['Authorization'])
        end

        def client_params
          params.permit(:email, :password, :password_confirmation)
        end
    end
  end
end