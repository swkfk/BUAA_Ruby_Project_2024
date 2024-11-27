Rails.application.routes.draw do
  resources :orders
  resources :order_items
  resources :comments
  resources :favorite_items
  resources :cart_items
  resources :goods
  resources :attr_colors
  resources :attr_tags

  resources :users do
    collection do
      get "login"
      post "do_login"
      get "logout"
      get "register"
      post "do_register"
    end
  end

  resources :user_roles
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "admin" => "users#admin"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
