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

      post 'auth/login', action: :login, controller: 'auth'
      post 'auth/confirm', action: :confirm, controller: 'auth'

      post 'users', action: :create, controller: 'users'
      put 'users', action: :update, controller: 'users'

      post 'company_info', action: :create, controller: 'company_info'
      put 'company_info', action: :update, controller: 'company_info' 

    end
  end

end
