module Api
    module V1
      class ReportsController < ApplicationController
        before_action :auth_creator, only: [:general, :clients, :orders, :sms]
  
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

        def clients
          render json: ReportsHelper.clients(
              @auth_user.creator.company,
              params[:begin_date], 
              params[:end_date], 
              params[:stores], 
              params[:loyalty_programs],
              params[:operators],
              params[:limit],
              params[:offset]
          )
      end

      def orders
        render json: ReportsHelper.orders(
            @auth_user.creator.company,
            params[:begin_date], 
            params[:end_date], 
            params[:stores], 
            params[:loyalty_programs],
            params[:operators],
            params[:limit],
            params[:offset]
        ), statistics: true
      end

      def sms
        render json: ReportsHelper.sms(
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