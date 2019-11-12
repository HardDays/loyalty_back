module Api
  module V1
    class ClientsController < ApplicationController
      before_action :auth_find, only: [:update]
      before_action :auth_operator, only: [:create, :index, :phone]
      before_action :auth_client, only: [:profile, :profile_orders, :update_profile]

      # GET /clients/profile
      def profile
        render json: @auth_user, points: true, loyalty_program: true
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
        render json: @auth_user.client.orders, store: true, loyalty_program: true, promotion: true
      end

      # GET /clients
      def index
        @users = User.joins(:client)
        if params[:name]
          @users = @users.where('lower(concat(users.first_name, \' \', users.last_name)) LIKE ?', "%#{params[:name].downcase}%").or(@users.where('lower(concat(users.last_name, \' \', users.first_name)) LIKE ?', "%#{params[:name].downcase}%"))
        end
        if params[:phone]
          @users = @users.where('phone LIKE ?', "%#{Phonelib.parse(params[:phone]).sanitized}%")
        end
        if params[:card_number]
          @users = @users.where(clients: {card_number: params[:card_number]})
        end
        render json: @users.limit(params[:limit]).offset(params[:offset]), points: true
      end

      # GET /clients/phone
      def phone
        render json: {
          status: User.joins(:client).where(phone: Phonelib.parse(params[:phone]).sanitized).count > 0
        }
      end

      # POST /clients
      def create
        ActiveRecord::Base.transaction do
          @user = User.new(user_params)
          password = '1234567' #SecureRandom.hex(4)
          @user.password = password
          if @user.save
            program = @auth_user.operator.company.loyalty_program
            @user.create_user_confirmation(confirm_status: :unconfirmed, code: '0000')
            @user.create_client(company: @auth_user.operator.company, loyalty_program: program)
            
            notification = ClientSms.new(sms_type: :registered, send_at: DateTime.now)
            notification.client = @user.client
            notification.sms_status = :sent
            notification.save
            SmsHelper.send_register(@user.client, password)

            if params[:recommendator_phone] && program && program.accrual_on_recommend
              rec_user = @users.where('phone LIKE ?', "%#{Phonelib.parse(params[:recommendator_phone]).sanitized}%").first
              if rec_user && rec_user.client
                points1 = ClientPoint.new(
                  current_points: program.recommend_registered_points,
                  initial_points: program.recommend_registered_points,
                  burning_date: DateTime.now + 100.years,
                  activation_date: DateTime.now,
                  client: @user.client,
                  loyalty_program: program,
                  points_source: :recommend_register
                )
                points1.save

                points2 = ClientPoint.new(
                  current_points: program.recommend_recommendator_points,
                  initial_points: program.recommend_recommendator_points,
                  burning_date: DateTime.now + 100.years,
                  activation_date: DateTime.now,
                  client: rec_user.client,
                  loyalty_program: program,
                  points_source: :recommend_recommendator
                )
                points2.save
              end
            end
            
            render json: @user
          else
            render json: @user.errors, status: :unprocessable_entity
          end
        end
      end

      # PUT /clients
      def update
        ActiveRecord::Base.transaction do
          if @user.update(user_params)
            @user.client.update(client_params)
            render json: @user
          else
            render json: @user.errors, status: :unprocessable_entity
          end
        end
      end

      private
        def auth
          @auth_user = User.authorize(request.headers['Authorization'])
        end

        def auth_operator
          auth
          @auth_user.role(@auth_user.operator_role)
        end

        def auth_client
          auth
          @auth_user.role(@auth_user.client_role)
        end

        def auth_find
          auth_operator
          set_user
          @auth_user.permission(@user.client, @auth_user.operator)
        end

        def set_user
          @user = User.find(params[:id])
        end

        def user_params
          params.permit(:phone, :email, :first_name, :last_name, :second_name, :gender)
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