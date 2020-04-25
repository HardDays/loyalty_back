module Api
    module V1
        class VkController < ApplicationController
            before_action :auth, only: [:create_group, :show_group, :update_group]
            
            # GET /vk/groups
            def show_group
                if @company.vk_group
                    render json: @company.vk_group
                else 
                    render status: :not_found
                end
            end

            # POST /vk/groups 
            def create_group
                if not @company.vk_group
                    group = VkGroup.new(group_params)
                    group.company = @company
                    group.confirmed = false
                    group.callback_code = SecureRandom.hex[0..8]
                    if group.save
                        render json: group
                    else
                        render json: group.errors, status: :unprocessable_entity
                    end
                else
                    render json: @company.vk_group
                end
            end

            # PUT /vk/groups 
            def update_group
                group = @company.vk_group
                if group
                    if group.update(group_params)
                        render json: group
                    else
                        render json: group.errors, status: :unprocessable_entity
                    end
                else
                    render status: :not_found
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
                            client_id = nil
                            points = 0
                            if params[:type] == 'group_join'
                                client_id = params[:object][:user_id]
                                points = group.group_join_points
                            else 
                                client_id = params[:object][:from_id]
                            end
                            client = Client.find_by(vk_id: client_id)
                            if client && client_id
                                post_id = nil
                                if params[:type] == 'wall_reply_new'
                                    post_id = params[:object][:post_id]
                                    points = group.wall_reply_points
                                elsif params[:type] == 'wall_repost'
                                    post_id = params[:object][:copy_history][0][:id]
                                    points = group.wall_repost_points
                                end
                                event = VkEvent.new(client_id: client.id, vk_group_id: group.id, event_type: params[:type], post_id: post_id)
                                if event.save
                                    points = ClientPoint.new(
                                        current_points: points,
                                        initial_points: points,
                                        burning_date: DateTime.now + 100.years,
                                        activation_date: DateTime.now,
                                        client_id: client.id,
                                        points_source: :vk
                                    )
                                    points.save
                                end
                            end
                            render plain: 'ok'
                        end
                    end
                end
            end
    
        
            private

           	def auth
                @auth_user = User.authorize(request.headers['Authorization'])
                @company = Company.find(params[:company_id])
                @auth_user.company_creator?(@company)
			end
            
            def group_params
                params.permit(:confirmation_code, :group_id, :group_join_points, :wall_repost_points, :wall_like_points, :wall_reply_points)
            end
        end
    end
end