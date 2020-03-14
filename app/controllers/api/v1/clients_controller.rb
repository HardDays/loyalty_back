module Api
  	module V1
		class ClientsController < ApplicationController
			before_action :auth_index, only: [:create, :index, :phone]
			before_action :auth_find_operator, only: [:update]
			before_action :auth_profile, only: [:profile, :profile_orders, :update_profile, :update_vk, :update_telegram]
			before_action :auth_find_creator, only: [:create_points, :remove_points]

			# GET /clients/profile
			def profile
				render json: @auth_user, points: true, loyalty_program: true
			end

			# POST /clients/profile/vk
			def update_vk
				begin
					client = @auth_user.client(@company)

					vk = VkontakteApi::Client.new(params[:access_token])
					vk_user = vk.users.get[0]
					
					client.vk_id = vk_user.id
					client.save
					render json: @auth_user, status: :ok
				rescue => ex
					puts json: ex
					render json: {"error_code": ex.error_code}, status: :unprocessable_entity
				end
			end

			# POST /clients/profile/telegram
			def update_telegram
				begin
					client = @auth_user.client(@company)
					
					client.telegram_username = params[:telegram_username]
					client.save
					render json: @auth_user, status: :ok
				rescue => ex
					render status: :unprocessable_entity
				end
			end

			# PUT /clients/profile
			def update_profile
				@user = @auth_user
				if params[:password] && !@user.authenticate(params[:current_password]) 
					render status: :forbidden
				else
					if @user.update(profile_params)
						render json: @user
					else
						render json: @user.errors, status: :unprocessable_entity
					end
				end
			end

			# GET /clients/profile/orders
			def profile_orders
				render json: @auth_user.client(@company).orders, store: true, loyalty_program: true, promotion: true
			end

			# GET /clients
			def index
				users = User.joins(:clients).where(clients: {company_id: @company.id})
				if params[:name]
					users = users.where('lower(concat(users.first_name, \' \', users.last_name)) LIKE ?', "%#{params[:name].downcase}%").or(users.where('lower(concat(users.last_name, \' \', users.first_name)) LIKE ?', "%#{params[:name].downcase}%"))
				end
				if params[:phone]
					users = users.where('phone LIKE ?', "%#{Phonelib.parse(params[:phone]).sanitized}%")
				end
				if params[:card_number]
					users = users.where(clients: {card_number: params[:card_number]})
				end
				render json: users.limit(params[:limit]).offset(params[:offset]), points: true
			end

			# GET /clients/phone
			def phone
				users = User.joins(:clients).where(clients: {company_id: @company.id}, phone: Phonelib.parse(params[:phone]).sanitized)
				render json: {
					status: users.count > 0
				}
			end

			# POST /clients
			def create
				ActiveRecord::Base.transaction do
					user = User.find_by(email: params[:email])
					if not user
						user = User.new(user_params)
						user.password = '1234567' #SecureRandom.hex(4)
					end
					
					if user.save
						program = @company.loyalty_program
						client = user.clients.build(
							operator: @auth_user.operator(@company), 
							company: @company, 
							loyalty_program: program, 
							card_number: params[:card_number]
						)
						if client.save
							#if !user.persisted?
							notification = ClientSms.new(sms_type: :registered, send_at: DateTime.now)
							notification.client = client
							notification.sms_status = :sent
							notification.save

							SmsHelper.send_register(client, user.password)

							user.create_user_confirmation(confirm_status: :confirmed, code: SecureRandom.hex[0..5])
							#end

							if program
								if program.accrual_on_register
									points = ClientPoint.new(
										current_points: program.register_points,
										initial_points: program.register_points,
										burning_date: DateTime.now + 100.years,
										activation_date: DateTime.now,
										client: client,
										loyalty_program: program,
										points_source: :registered
									)
									points.save
								end
								if client.card_number
									card = Card.find_by(number: client.card_number, company_id: @company.id)
									if card
										points = ClientPoint.new(
											current_points: card.points,
											initial_points: card.points,
											burning_date: DateTime.now + 100.years,
											activation_date: DateTime.now,
											client: client,
											points_source: :card
										)
										points.save
									end
								end

								if params[:recommendator_phone] && program.accrual_on_recommend
									rec_user = User.where('phone LIKE ?', "%#{Phonelib.parse(params[:recommendator_phone]).sanitized}%").where(company_id:  @company.id).first
									if rec_user && rec_user.client(@company)
										points1 = ClientPoint.new(
											current_points: program.recommend_registered_points,
											initial_points: program.recommend_registered_points,
											burning_date: DateTime.now + 100.years,
											activation_date: DateTime.now,
											client: client,
											loyalty_program: program,
											points_source: :recommend_register
										)
										points1.save

										points2 = ClientPoint.new(
											current_points: program.recommend_recommendator_points,
											initial_points: program.recommend_recommendator_points,
											burning_date: DateTime.now + 100.years,
											activation_date: DateTime.now,
											client: rec_user.client(@company),
											loyalty_program: program,
											points_source: :recommend_recommendator
										)
										points2.save

										#user.client.recommendator_id = rec_user.client.id
									end
								end
							end
							render json: user
						else
							render json: client.errors, status: :unprocessable_entity
							raise ActiveRecord::Rollback
						end
					else
						render json: user.errors, status: :unprocessable_entity
						raise ActiveRecord::Rollback
					end
				end
			end

			# PUT /clients/:id
			def update
				ActiveRecord::Base.transaction do
					client = @user.client(@company)
					if client.update(client_params)
						render json: @user
					else
						render json: client.errors, status: :unprocessable_entity
					end
				end
			end

			# POST /clients/:id/points
			def create_points
				points = ClientPoint.new(
					current_points: params[:points].to_i,
					initial_points: params[:points].to_i,
					burning_date: DateTime.now + 100.years,
					activation_date: DateTime.now,
					client: @user.client(@company),
					operator: @auth_user.operator(@company),
					points_source: :operator
				)
				if points.save
					render status: :ok
				else
					render json: points.errors, status: :unprocessable_entity
				end
			end

			# DELETE /clients/:id/points
			def remove_points
				if params[:points]
					ClientPointsHelper.write_off_number(@user.client(@company), [params[:points].to_i, 0].max)
					render status: :ok
				end
			end

			private
			
			def set_user
				@user = User.find(params[:id])
			end

			def auth
				@auth_user = User.authorize(request.headers['Authorization'])
				@company = Company.find(params[:company_id])
			end

			def auth_index
				auth
				@auth_user.company_operator_creator?(@company)
			end

			def auth_find_operator
				auth
				@auth_user.company_operator?(@company)
				set_user
				@user.company_client?(@company)
			end

			def auth_find_creator
				auth
				@auth_user.company_creator?(@company)
				set_user
				@user.company_client?(@company)
			end


			def auth_profile
				auth
				@auth_user.company_client?(@company)
			end

			def user_params
				params.permit(:phone, :email, :first_name, :last_name, :second_name, :gender, :birth_day)
			end

			def profile_params
				params.permit(:first_name, :last_name, :second_name, :gender)
			end

			def client_params
				params.permit(:loyalty_program_id, :card_number)
			end
		end
	end
end