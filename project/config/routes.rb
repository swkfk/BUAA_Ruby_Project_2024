Rails.application.routes.draw do
  resources :images, only: [ :index, :create, :destroy ]

  resources :orders, except: [ :create ] do
    collection do
      post "do_create_order"
    end
  end
  resources :order_items, only: []
  resources :comments, except: [ :index, :show, :new, :edit ]
  resources :favorite_items, except: [ :edit, :update ]
  resources :cart_items, except: [ :show, :new, :edit ]
  resources :goods do
    collection do
      get "edit_good_attribute"
      post "do_edit_good_attribute"
    end
  end
  resources :attr_colors, except: [ :index, :show, :new, :edit ]
  resources :attr_tags, except: [ :index, :show, :new, :edit ]

  resources :users, except: [ :index, :destroy ] do
    collection do
      get "login"
      post "do_login"
      get "logout"
      get "register"
      post "do_register"
      post "update_password"
      post "reset_password"
    end
  end

  resources :user_roles, only: []
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
