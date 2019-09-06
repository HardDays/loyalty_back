module Api
    module V1
      class ReportsController < ApplicationController
        before_action :auth_creator, only: [:general]
  
        def general
            render json: ReportsHelper.general(
                @auth_user.creator.company,
                params[:begin_date], 
                params[:end_date], 
                params[:stores], 
                params[:loyalty_programs],
                params[:operators]
            )
        end

        private
          def auth
            @auth_user = User.authorize(request.headers['Authorization'])
          end
          
          def auth_creator
            auth
            @auth_user.permission(@auth_user.creator)
          end
      end
    end
  end