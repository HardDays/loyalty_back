
module Api
  module V1
    class CallBackController < ApplicationController
      def index
        callbacks = CallBack.order('created_at DESC')
        render json:{status:'SUCCESS', messages:'Callback list', data:callbacks}, status: :ok
      end

      def show
        callback = CallBack.find(params[:id])
        render json:{status:'SUCCESS', messages:'Callback list', data:callback}, status: :ok
      end

      def create
        callback = CallBack.new(callback_params)
        # TODO: Set this val as default on model 0-new, 1-completed, 2-hold, 3-closed
        # Dont work =(
        callback_params[:status] = 0
        if callback.save
          render json:{status:'SUCCESS', messages:'Callback created', data:callback_params}, status: :created
        else
          render json:{status:'ERROR', messages:'Callback failed when creating', data:callback.errors}, status: :unprocessable_entity
        end
      end

      def destroy
        callback = CallBack.find(params[:id])
        callback.destroy
        render json:{status:'SUCCESS', messages:'Callback removed', data:callback}, status: :ok
      end

      def update
        callback = CallBack.find(params[:id])
        if callback.update_attributes(company_params)
          render json:{status:'SUCCESS', messages:'Callback updated', data:callback}, status: :created
        else
          render json:{status:'ERROR', messages:'Callback failed when updating', data:callback.errors}, status: :unprocessable_entity
        end
      end

      private
      def callback_params
        params.permit(:company_id, :phone, :status)
      end
    end
  end
end