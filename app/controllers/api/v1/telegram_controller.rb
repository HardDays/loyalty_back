module Api
    module V1
        class TelegramController < ApplicationController
            before_action :auth, only: [:create_group]
            
             # POST /telegram/groups 
             def create_group
                if not @company.telegram_group
                    group = TelegramGroup.new
                    group.company = @company
                    group.bot_code = SecureRandom.hex[0..10]
                    if group.save
                        render json: group
                    else
                        render json: group.errors, status: :unprocessable_entity
                    end
                else
                    render json: @company.telegram_group
                end
            end

            # POST /telegram/callback 
            def callback
               puts params[:message]
                
            end
    
        
        private

           	def auth
                @auth_user = User.authorize(request.headers['Authorization'])
                @company = Company.find(params[:company_id])
                @auth_user.company_creator?(@company)
			end
        end
    end
end