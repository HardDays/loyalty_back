Rails.application.routes.draw do
  # namespace 'api' do
  #   namespace 'v1' do
  #     resources :company
  #     resources :company_info
  #     resources :call_back
  #   end
  # end

  namespace 'api' do
    namespace 'v1' do
      resources :company
      resources :store
      resources :clients

      # TODO: Переделать
      # post 'auth/login', action: :login, controller: 'auth'
      # post 'auth/confirm', action: :confirm, controller: 'auth'

      post 'creator', action: :create, controller: 'creators'
      put 'creator', action: :update, controller: 'creator'

      post 'operator', action: :create, controller: 'operators'
      put 'operator', action: :update, controller: 'operators'

    end
  end

end
