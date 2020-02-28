
Rails.application.routes.draw do
  #apipie
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  #TODO:!!!!!!!!!!!!!!!!!!!!!!!!! filter nested models in GET clients etc !!!!!!!!!!!!!

  namespace 'api' do
    namespace 'v1' do

      post 'auth/login', action: :login, controller: 'auth'
      post 'auth/confirm', action: :confirm, controller: 'auth'
      post 'auth/password/request', action: :request_password, controller: 'auth'
      post 'auth/password/update', action: :update_password, controller: 'auth'

      get 'creators', action: :show, controller: 'creators'
      post 'creators', action: :create, controller: 'creators'
      put 'creators/profile', action: :update_profile, controller: 'creators'

      get 'clients', action: :index, controller: 'clients'
      get 'clients/phone', action: :phone, controller: 'clients'
      get 'clients/profile', action: :profile, controller: 'clients'
      get 'clients/profile/orders', action: :profile_orders, controller: 'clients'
      post 'clients', action: :create, controller: 'clients'
      post 'clients/profile/confirm/vk', action: :confirm_vk, controller: 'clients'
      post 'clients/:id/points', action: :create_points, controller: 'clients'
      put 'clients/profile', action: :update_profile, controller: 'clients'
      put 'clients/:id', action: :update, controller: 'clients'
      delete 'clients/:id/points', action: :remove_points, controller: 'clients'

      get 'operators', action: :index, controller: 'operators'
      get 'operators/:id', action: :show, controller: 'operators'
      post 'operators', action: :create, controller: 'operators'
      put 'operators/:id', action: :update, controller: 'operators'
      #delete 'operators/:id', action: :destroy, controller: 'operators'

      post 'cards', action: :create, controller: 'cards'
      post 'cards/range', action: :create_range, controller: 'cards'

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

      post 'vk/groups', action: :create_group, controller: 'vk'
      post 'vk/callback/:id/:code', action: :callback, controller: 'vk'

      post 'telegram/groups', action: :create_group, controller: 'telegram'
      post 'telegram/callback/oggfhgdufugvmdfghd8f4ngf', action: :callback, controller: 'telegram'

      get 'loyalty_levels/:id', action: :show, controller: 'loyalty_levels'
      post 'loyalty_levels', action: :create, controller: 'loyalty_levels'
      put 'loyalty_levels/:id', action: :update, controller: 'loyalty_levels'
      delete 'loyalty_levels/:id', action: :destroy, controller: 'loyalty_levels'

      get 'promotions', action: :index, controller: 'promotions'
      get 'promotions/:id', action: :show, controller: 'promotions'
      post 'promotions', action: :create, controller: 'promotions'
      put 'promotions/:id', action: :update, controller: 'promotions'
      delete 'promotions/:id', action: :destroy, controller: 'promotions'

      get 'orders/loyalty_program/points', action: :show_program_points, controller: 'orders'
      get 'orders/promotion/points', action: :show_promotion_points, controller: 'orders'
      post 'orders/loyalty_program', action: :create_program_order, controller: 'orders'
      post 'orders/promotion', action: :create_promotion_order, controller: 'orders'

      get 'reports/general', action: :general, controller: 'reports'
      get 'reports/clients', action: :clients, controller: 'reports'
      get 'reports/orders', action: :orders, controller: 'reports'
      get 'reports/sms', action: :sms, controller: 'reports'

      get 'tariff_plans', action: :index, controller: 'tariff_plans'
      post 'tariff_plans/purchase', action: :purchase, controller: 'tariff_plans'

      post 'sms', action: :create, controller: 'sms'
    end
  end
end
