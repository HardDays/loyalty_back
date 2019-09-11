module Api
    module V1
        class AuthController < ApplicationController

            # POST /auth/login
            def login
                if params[:phone]
                    @user = User.find_by(phone: params[:phone])
                else
                    @user = User.find_by(email: params[:email]) 
                end
                if @user 
                    if @user.authenticate(params[:password]) 
                        if @user.user_confirmation.confirm_status.to_sym == :confirmed
                            render json: @user, token: true
                        else
                            render status: :forbidden
                        end
                    else
                        render status: :unauthorized
                    end
                else
                    render status: :not_found
                end
            end

            # POST /auth/confirm
            def confirm
                if params[:phone]
                    @user = User.find_by(phone: params[:phone])
                else
                    @user = User.find_by(email: params[:email])
                end
                if @user
                    @confirmation = UserConfirmation.find_by(user_id: @user.id, code: params[:code])     
                    if @confirmation 
                        @confirmation.confirm_status = :confirmed
                        @confirmation.save
                        render json: @confirmation.user, token: true, status: :ok
                    else
                        render status: :not_found
                    end
                else
                    render status: :not_found
                end
            end

            # POST /auth/password/request
            def request_password
                if params[:phone]
                    @user = User.find_by(phone: params[:phone])
                else
                    @user = User.find_by(email: params[:email])
                end
                if @user
                    @confirmation = PasswordReset.new(user_id: @user.id, code: SecureRandom.hex, confirm_status: :unconfirmed)
                    @confirmation.save
                    #TODO: send sms
                else
                    render status: :not_found
                end
            end

            # POST /auth/password/update
            def update_password
                @confirmation = PasswordReset.find_by(code: params[:code], confirm_status: :unconfirmed) 
                if @confirmation
                    @confirmation.confirm_status = :confirmed
                    @confirmation.save

                    @user = @confirmation.user
                    @user.password = params[:password]
                    @user.password_confirmation = params[:password_confirmation]
                    if @user.save
                        render json: @user
                    else
                        render json: @user.errors, status: :unprocessable_entity
                    end
                else
                    render status: :not_found
                end
            end
        end
    end
end