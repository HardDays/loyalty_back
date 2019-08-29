
module Api
  module V1
    class CallBackController < ApplicationController
      # def index
      #   callbacks = CallBack.order('created_at DESC')
      #   render json:{status:'SUCCESS', messages:'Callback list', data:callbacks}, status: :ok
      # end

      # def show
      #   callback = CallBack.find(params[:id])
      #   render json:{status:'SUCCESS', messages:'Callback list', data:callback}, status: :ok
      # end

      def create
        @callback = CallBack.new(callback_params)
        @callback.status = :new
        
        if @callback.save
          render json: @callback, status: :created
        else
          render json: @callback.errors, status: :unprocessable_entity
        end
      end

      private
        def callback_params
            params.permit(:company_id, :phone, :status)
        end
    end
  end
end