module Api
    module V1
      class VkController < ApplicationController
        before_action :auth_creator, only: [:create_settings]
        
        # POST /vk/settings 
        def create_settings
            settings = VkSetting.new(settings_params)
            settings.company = @company
            settings.confirmed = false
            settings.callback_code = SecureRandom.hex[0..6]
            if settings.save
                render json: settings, status: :ok
            else
                render json: settings.errors, status: :unprocessable_entity
            end
        end
        
        # POST /vk/callback 
        def callback
            company = Company.find(params[:id])
            if company 
                settings = company.vk_setting
                if settings && settings.callback_code == params[:code]
                    if params[:type] == 'confirmation'
                        settings.confirmed = true
                        settings.save
                        render settings.confirmation_code
                    else
                        render 'ok'
                    end
                end
            end
        end
  
     
        private
            def auth
                @auth_user = User.authorize(request.headers['Authorization'])
            end
      
            def auth_creator
                auth
                @auth_user.role(@auth_user.creator_role)
                @company = @auth_user.creator.company
            end
            
            def settings_params
                params.permit(:confirmation_code)
            end
         
        end
    end
end