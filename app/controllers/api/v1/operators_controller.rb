module Api
  	module V1
   		class OperatorsController < ApplicationController
			before_action :auth_create, only: [:create, :index]
			before_action :auth_find, only: [:update, :destroy, :show]

			# GET /operators 
			def index
				operators = @company.operators
				if params[:store_id]
					operators = operators.where(store_id: params[:store_id])
				end
				render json: operators.limit(params[:limit]).offset(params[:offset]).collect{|o| o.user}, company: @company
			end

			# GET /operators/:id
			def show
				render json: @user
			end

			# POST /operators 
			def create
				ActiveRecord::Base.transaction do
					new_user = false
					user = User.find_by('email = ? OR phone = ?', params[:email], Phonelib.parse(params[:phone]).sanitized)
					if not user
						user = User.new(user_params)
						user.password = '1234567' #SecureRandom.hex(4)
						new_user = true
					end
					
					operator = user.operators.build(
						store_id: params[:store_id], 
						company: @company,
						operator_status: :active
					)
					if user.save
						if operator.save
							if new_user
								user.create_user_confirmation(confirm_status: :confirmed)
								begin
									PasswordMailer.password_email(user, user.password).deliver!
								rescue => ex
									puts 'EMAIL ERROR'
									puts json: ex
								end
							end
							render json: user, company: @company, role: :operator
						else
							render json: operator.errors, status: :unprocessable_entity
							raise ActiveRecord::Rollback
						end
					else
						render json: user.errors, status: :unprocessable_entity
						raise ActiveRecord::Rollback
					end
				end
			end

			# PUT /operators/:id
			def update
				ActiveRecord::Base.transaction do
					operator = @user.any_operator(@company)
					if operator.update(operator_params)
						render json: @user, company: @company
					else 
						puts json: operator.errors
						render json: operator.errors, status: :unprocessable_entity
					end
				end
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
				@user = User.find(params[:id])
				@user.any_operator?(@company)
			end

			def operator_params
				params.permit(:store_id, :operator_status,)
			end

			def user_params
				params.permit(:email, :phone, :first_name, :last_name, :second_name)
			end
    	end
  	end
end