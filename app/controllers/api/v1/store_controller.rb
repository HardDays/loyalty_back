
module Api
  module V1
    class StoreController < ApplicationController

      def index
        @stores = Store.order('created_at DESC')
        render json:@stores, status: :ok
      end

      def show
        @store = Store.find_by(id:params[:id])
        render json:@store, status: :ok
      end

      def create
        @store = Store.new(store_info_params)
        if @store.save
           render json: @store, status: :created
        else
           render json: @store.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @store = Store.find(params[:id])
        @store.destroy
        render @store, status: :ok
      end

      def update
        if @store.update(store_info_params)
          render json: @store, status: :ok
        else
          render json: @store.errors, status: :unprocessable_entity
        end
      end

      private
        # def auth
        #   @user = Creator.authorize(request.headers['Authorization'])
        # end
        #
        # def auth_creator
        #   auth
        #   @company = @user.company_info
        # end

        def store_info_params
          params.permit(:name)
        end
    end
  end
end