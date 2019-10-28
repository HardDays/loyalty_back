module Api
  module V1
    class StoresController < ApplicationController
      
      before_action :auth_creator, only: [:index, :create]
      before_action :auth_find, only: [:show, :update, :destroy]

      def index
        @stores = @auth_user.creator.company.stores.order('created_at DESC')
        render json: @stores.limit(params[:limit]).offset(params[:offset])
      end

      def show
        render json: @store
      end

      def create
        @store = Store.new(store_params)
        @store.company = @auth_user.creator.company
        if @store.save
          render json: @store
        else
          render json: @store.errors, status: :unprocessable_entity
        end
      end

      def update
        if @store.update(store_params)
          render json: @store, status: :ok
        else
          render json: @store.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @store.destroy
      end

      private
        def auth
          @auth_user = User.authorize(request.headers['Authorization'])
        end
        
        def auth_creator
          auth
          @auth_user.role(@auth_user.creator)
        end

        def auth_find
          auth_creator
          set_store
          @auth_user.creator_permission(@store)
        end

        def set_store
          @store = Store.find(params[:id])
        end

        def store_params
          params.permit(:name, :country, :city, :street, :house)
        end
    end
  end
end