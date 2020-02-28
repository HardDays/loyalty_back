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
                begin
                    if params[:message] && params[:message][:text]
                        text = params[:message][:text].split(' ')
                        if text[0] == '/set_group'
                            group = TelegramGroup.find_by(bot_code: text[1])
                            if group
                                group.group_id = params[:message][:chat][:id]
                                group.save
                            end
                        end
                    end
                    if params[:message] && params[:message][:new_chat_participant]
                        group = TelegramGroup.find_by(group_id: params[:message][:chat][:id])
                        if group
                            client = Client.find_by(telegram_username: params[:message][:new_chat_participant][:username])
                            if client
                                event = TelegramEvent.new(client_id: client.id, telegram_group_id: group.id, event_type: :group_join)
                                event.save
                            end
                        end
                    end
                rescue => ex
                    puts ex
                end
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