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
                            render status: :unauthorized
                        end
                    else
                        render status: :unauthorized
                    end
                else
                    render status: :not_found
                end
            end

            # POST /auth/confirm/phone
            def confirm_phone
                # if params[:confirm_hash]
                #     @user = User.find_by(email: params[:email])
                #     @confirmation = UserConfirmation.find_by(user_id: @user.id, confirm_hash: params[:confirm_hash])
                # else 
                @user = User.find_by(phone: params[:phone])
                @confirmation = UserConfirmation.find_by(user_id: @user.id, code: params[:code])                
                #end
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