require 'api_constraints'

Auth::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config, :users

  root to: "sessions#new"

  get 'sessions/customer'
  get 'sessions/index'
  get 'sessions/show'
  get 'sessions/enter'
  get 'sessions/delete_page'
  get 'sessions/delete_account'
  get 'vendors/home'
  get 'vendors/edit'
  get 'vendors/upload_page'
  get 'vendors/viewCodes'
  get 'vendors/profile'
  get 'vendors/change_to_user'
  get 'vendors/clear_history'
  get 'sessions/change_to_vendor'
  get 'admin/login'

  get 'vendors/new'


  get 'providers/index'
  get 'providers/home'
  get 'providers/edit'
  get 'providers/upload_page'
  get 'providers/clear_history'

  match "/auth/:provider/callback", to: "sessions#create", via: [:get, :post]
  match "/auth/failure", to: "sessions#failure", via: [:get, :post]
  match "/logout", to: "sessions#destroy", :as => "logout", via: [:get, :post]
  match "/logout", to: "vendors#destroy", :as => "logout2", via: [:get, :post]

  resources :sessions

  #match "/users/:user_id/redeemify_codes/:code", to: "redeemify_codes#show", via: [:get]
  resources :users do
    resources :provider
    resources :redeemify_codes, shallow: true
  end

  resources :vendors do
    collection do
      post :import
      post :update_profile
      get :remove_codes
    end
    resources :vendorcodes
  end

  resources :providers do
    collection do
      post :import2
      post :update_profile
      get :remove_codes
    end
    resources :redeemifycodes
  end

  # Api definition
  namespace :api, defaults: { format: :json },
            constraints: { subdomain: 'api' }, path: '/'  do
    scope module: :v1,
          constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, :only => [:show]
    end
  end

  ActiveAdmin.routes(self)
end
