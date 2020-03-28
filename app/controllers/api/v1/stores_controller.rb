module Api
  	module V1
    	class StoresController < ApplicationController
		
			before_action :auth_create, only: [:index, :create]
			before_action :auth_find, only: [:show, :update, :destroy]

			def index
				stores = @company.stores.order('created_at DESC')
				render json: stores.limit(params[:limit]).offset(params[:offset])
			end

			def show
				render json: @store
			end

			def create
				store = Store.new(store_params)
				store.company = @company
				if store.save
					render json: store
				else
					render json: store.errors, status: :unprocessable_entity
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
				@company = Company.find(params[:company_id])
			end

			def auth_create
				auth
				@auth_user.company_creator?(@company)
			end

			def auth_find
				auth_create
				@store = Store.find(params[:id])
				@auth_user.company_creator?(@store.company)
			end
	

			def store_params
				params.permit(:name, :country, :city, :street, :house)
			end
    	end
  	end
end