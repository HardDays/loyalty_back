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
      # resources :company
      # resources :store
      # resources :clients

      post 'auth/login', action: :login, controller: 'auth'
      post 'auth/confirm', action: :confirm, controller: 'auth'

      post 'creators', action: :create, controller: 'creators'
      
      post 'clients', action: :create, controller: 'clients'
      put 'clients/:id', action: :update, controller: 'clients'

      get 'operators', action: :index, controller: 'operators'
      post 'operators', action: :create, controller: 'operators'
      put 'operators/:id', action: :update, controller: 'operators'
      delete 'operators/:id', action: :destroy, controller: 'operators'

      get 'companies', action: :show, controller: 'companies'
      post 'companies', action: :create, controller: 'companies'
      put 'companies', action: :update, controller: 'companies'

      get 'stores', action: :index, controller: 'stores'
      get 'stores/:id', action: :show, controller: 'stores'
      post 'stores', action: :create, controller: 'stores'
      put 'stores/:id', action: :update, controller: 'stores'
      delete 'stores/:id', action: :destroy, controller: 'stores'

      get 'loyalty_programs', action: :index, controller: 'loyalty_programs'
      get 'loyalty_programs/:id', action: :show, controller: 'loyalty_programs'
      post 'loyalty_programs', action: :create, controller: 'loyalty_programs'
      put 'loyalty_programs/:id', action: :update, controller: 'loyalty_programs'
      delete 'loyalty_programs/:id', action: :destroy, controller: 'loyalty_programs'

      post 'orders', action: :create, controller: 'orders'

    end
  end

end
