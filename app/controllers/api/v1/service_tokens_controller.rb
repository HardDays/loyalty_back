module Api
    module V1
        class ServiceTokensController < ApplicationController
            before_action :auth_creator, only: [:show]

            def show
                if not @company.service_token
                    token = ServiceToken.new(one_s: SecureRandom.hex)
                    token.company = @company
                    token.save
                end
                render json: @company.service_token, only: params[:token_type]
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
        end
    end
end