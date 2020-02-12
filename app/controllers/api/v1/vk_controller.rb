module Api
    module V1
      class VkController < ApplicationController
        before_action :auth_creator, only: [:create_group]
        
        # POST /vk/groups 
        def create_group
            if not @company.vk_group
                group = VkGroup.new(group_params)
                group.company = @company
                group.confirmed = false
                group.callback_code = SecureRandom.hex[0..8]
                if group.save
                    render json: group, status: :ok
                else
                    render json: group.errors, status: :unprocessable_entity
                end
            else
                render json: @company.vk_group
            end
        end
        
        # POST /vk/callback 
        def callback
            company = Company.find(params[:id])
            if company 
                group = company.vk_group
                if group && group.callback_code == params[:code]
                    if params[:type] == 'confirmation'
                        group.confirmed = true
                        group.save
                        render plain: group.confirmation_code
                    else
                        client = Client.find_by(vk_id: params[:object][:from_id])
                        if client
                            post_id = nil
                            if params[:type] == 'wall_reply_new'
                                post_id = params[:object][:post_id]
                            elsif params[:type] == 'wall_repost'
                                post_id = params[:object][:copy_history][0][:id]
                            end
                            event = VkEvent.new(client_id: client.id, group_id: group.id, event_type: params[:type], post_id: post_id)
                            event.save
                            # event = VkEvent.find_by(event_type: params[:type], client_id: client.id, group_id: group.id, post_id: post_id)
                            # if not event
                            #     event = VkEvent.new(client_id: client.id, group_id: group.id, event_type: params[:type], post_id: post_id)
                            #     event.save
                            #     #todo: add points
                            # end
                        end
                        render plain: 'ok'
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
            
            def group_params
                params.permit(:confirmation_code, :group_id)
            end
         
        end
    end
end