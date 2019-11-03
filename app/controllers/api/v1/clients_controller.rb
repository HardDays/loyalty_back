module Api
  module V1
    class ClientsController < ApplicationController
      before_action :auth_find, only: [:update]
      before_action :auth_operator, only: [:create, :index, :phone]
      before_action :auth_client, only: [:profile]

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

      # GET /clients/profile
      def profile
        render json: @auth_user, points: true, loyalty_program: true
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
            @user.create_user_confirmation(confirm_status: :unconfirmed, code: SecureRandom.hex(2))
            @user.create_client(company: @auth_user.operator.company, loyalty_program: @auth_user.operator.company.loyalty_program)
            
            notification = ClientSms.new(sms_type: :registered, send_at: DateTime.now)
            notification.client = @user.client
            notification.sms_status = :sent
            notification.save
            SmsHelper.send_register(@user.client, password)
            
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
          @auth_user.role(@auth_user.operator)
        end

        def auth_client
          auth
          @auth_user.role(@auth_user.client)
        end

        def auth_find
          auth_operator
          set_user
          @auth_user.operator_permission(@user.client)
        end

        def set_user
          @user = User.find(params[:id])
        end

        def user_params
          params.permit(:phone, :email, :first_name, :last_name, :second_name, :gender, :birth_day)
        end

        def client_params
          params.permit(:loyalty_program_id, :card_number)
        end
    end
  end
end