module Api
    module V1
        class AuthController < ApplicationController
            # POST /auth/creator/login
            def creator_login
                @creator = Creator.find_by(email: params[:email])
                if @creator 
                    if @creator.authenticate(params[:password]) && @creator.creator_confirmation.confirm_status.to_sym == :confirmed
                        render json: @creator, token: true, status: :ok
                    else
                        render json: {message: "This user is not confirmed"}, status: :unauthorized
                    end
                else
                    render status: :not_found
                end
            end

            # POST /auth/client/login
            def client_login
                @client = Client.find_by(phone: params[:phone])
                if @client 
                    if @client.authenticate(params[:password])
                        render json: @client, token: true, status: :ok
                    else
                        render status: :unauthorized
                    end
                else
                    render status: :not_found
                end
            end

            # POST /auth/operator/login
            def client_login
                @operator = Client.find_by(email: params[:email])
                if @operator 
                    if @operator.authenticate(params[:password])
                        render json: @operator, token: true, status: :ok
                    else
                        render status: :unauthorized
                    end
                else
                    render status: :not_found
                end
            end

            # POST /auth/creator/confirm
            def creator_confirm
                @confirmation = CreatorConfirmation.find_by(confirm_hash: params[:confirm_hash])
                if @confirmation 
                    @confirmation.confirm_status = :confirmed
                    @confirmation.save
                    render json: @confirmation.creator, token: true, status: :ok
                else
                    render status: :not_found
                end
            end
        end
    end
end