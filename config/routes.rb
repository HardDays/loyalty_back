Rails.application.routes.draw do
  #apipie
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
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
      post 'auth/password/request', action: :request_password, controller: 'auth'
      post 'auth/password/update', action: :update_password, controller: 'auth'

      post 'creators', action: :create, controller: 'creators'
      
      get 'clients/profile', action: :profile, controller: 'clients'
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
      post 'stores', action: :create, controller: 'stores'
      put 'stores/:id', action: :update, controller: 'stores'
      delete 'stores/:id', action: :destroy, controller: 'stores'

      get 'loyalty_programs', action: :index, controller: 'loyalty_programs'
      get 'loyalty_programs/:id', action: :show, controller: 'loyalty_programs'
      post 'loyalty_programs', action: :create, controller: 'loyalty_programs'
      put 'loyalty_programs/:id', action: :update, controller: 'loyalty_programs'
      # delete 'loyalty_programs/:id', action: :destroy, controller: 'loyalty_programs'

      get 'loyalty_levels', action: :list, controller: 'loyalty_levels'
      post 'loyalty_levels', action: :create, controller: 'loyalty_levels'
      put 'loyalty_levels/:id', action: :update, controller: 'loyalty_levels'
      delete 'loyalty_levels/:id', action: :destroy, controller: 'loyalty_levels'

      post 'loyalty_promotions', action: :create, controller: 'loyalty_promotion'
      put 'loyalty_promotions/:id', action: :update, controller: 'loyalty_promotion'
      delete 'loyalty_promotions/:id', action: :destroy, controller: 'loyalty_promotion'

      get 'orders/points', action: :show_points, controller: 'orders'
      post 'orders', action: :create, controller: 'orders'

      get 'reports/general', action: :general, controller: 'reports'
      get 'reports/clients', action: :clients, controller: 'reports'
      get 'reports/orders', action: :orders, controller: 'reports'
      get 'reports/sms', action: :sms, controller: 'reports'
    end
  end
end
