module Api
    module V1
        class AuthController < ApplicationController
            # POST /auth/login
            def login
                @user = User.find_by(email: params[:email])
                if @user 
                    if @user.authenticate(params[:password])
                        render json: @user, token: true, status: :ok
                    else
                        render status: :unauthorized
                    end
                else
                    render status: :not_found
                end
            end

            # POST /auth/confirm
            def confirm
                @confirmation = UserConfirmation.find_by(confirm_hash: params[:confirm_hash])
                if @confirmation 
                    @confirmation.confirm_status = :confirmed
                    @confirmation.save
                    render json: @confirmation.user, token: true, status: :ok
                else
                    render status: :not_found
                end
            end
        end
    end
end