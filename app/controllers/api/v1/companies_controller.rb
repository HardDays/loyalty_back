module Api
  	module V1
		class CompaniesController < ApplicationController
			before_action :auth, only: [:create]
			before_action :auth_creator, only: [:show, :update]

			def show
				render json: @company, tariff_plan: true, status: :ok
			end

			def create
				ActiveRecord::Base.transaction do
					company = Company.new(company_params)
					creator = @auth_user.creators.build
					if creator.save
						company.creator = creator
						if company.save
							render json: company
						else
							render json: company.errors, status: :unprocessable_entity
							raise ActiveRecord::Rollback
						end
					else
						render json: creator.errors, status: :unprocessable_entity
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
				@company = Company.find(params[:company_id])
				@auth_user = User.authorize(request.headers['Authorization'])
				@auth_user.company_creator?(@company)
			end

			def company_params
				params.permit(:name)
			end
		end
  	end
end