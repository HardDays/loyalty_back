module Api
  module V1
    class SmsController < ApplicationController
      before_action :auth_creator, only: [:create]

      def create
        if params[:message] && params[:message].length > 0
          @clients = @auth_user.creator.company.clients
          if params[:loyalty_program_id]
            @clients= @clients.where(loyalty_program_id: params[:loyalty_program_id]).includes(:user)
          end
          @clients.each do |c|
            SmsHelper.send(c.user.phone, params[:message])
          end
        end
        render status: :ok
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