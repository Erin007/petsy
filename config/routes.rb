Rails.application.routes.draw do

  root to: 'homepages#index'

  # get 'sessions/create'

  get '/products/by_merchant/:merchant_id' => 'products#by_merchant', as: 'by_merchant'

  get 'users/:id/purchase_history' => 'users#purchase_history', as: 'purchase_history'

  get 'users/:id/selling_history' => "users#selling_history", as: 'selling_history'

  get '/auth/:provider/callback' =>  'sessions#create'

  delete '/sessions/destroy' => "sessions#destroy", as: 'destroy_session'

  delete '/order/cancel' => "users#delete_order", as: 'cancel_order'

  patch '/users/:id/selling_history/mark_shipped' => "users#mark_shipped", as: 'mark_shipped'

  resources :products do
    get 'reviews/new'
    post 'reviews/create'
  end

  resources :products do
    member do
      patch 'activation'
      get 'activation'
    end
  end

  resources :order_products, :users, :orders

  get 'homepages/index'

  get 'homepages/show'

  # get 'sessions/create'
  #
  # get 'sessions/destroy'

  # get 'orders/new'
  #
  # get 'orders/create'
  #
  # get 'orders/index'
  #
  # get 'orders/show'
  #
  # get 'orders/update'
  #
  # get 'orders/edit'
  #
  # get 'orders/destroy'
  #
  # get 'reviews/new'
  #
  # get 'reviews/create'
  #
  # get 'reviews/index'
  #
  # get 'reviews/show'
  #
  # get 'reviews/update'
  #
  # get 'reviews/edit'
  #
  # get 'reviews/destroy'

  # get 'products/new'
  #
  # get 'products/create'
  #
  # get 'products/index'
  #
  # get 'products/show'
  #
  # get 'products/update'
  #
  # get 'products/edit'
  #
  # get 'products/destroy'

  # get 'users/new'
  #
  # get 'users/create'
  #
  # get 'users/index'
  #
  # get 'users/show'
  #
  # get 'users/edit'
  #
  # get 'users/update'
  #
  # get 'users/destroy'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
