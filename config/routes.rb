ChwinkApp::Application.routes.draw do
  devise_for :users
  
  match '/get_recent_activity', to: 'chwinks#get_recent_activity', via: :get  
  match '/auth/:provider/callback', to: 'authentications#create'
  match '/auth/failure', to: 'authentications#failure'
  match '/chwinks/search', to: 'chwinks#index'
  match '/categories/:category_id', to: 'chwinks#index', as: 'category_chwinks'
  get 'search', to: 'search#index'
  post 'chwinks/autocomplete', to: 'chwinks#autocomplete'
  
  resources :chwinks do
    get '/vote/:year', to: 'chwinks#vote'
    post '/comment', to: 'chwinks#comment'
  end
  
  
  resources :categories do

  end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
