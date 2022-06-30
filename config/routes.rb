Rails.application.routes.draw do
  root 'static_pages#home'
  get   '/home'       =>  'static_pages#home'
  get   '/help'       =>  'static_pages#help'
  get   '/about'      =>  'static_pages#about'
  get   '/contact'    =>  'static_pages#contact'
  get   '/signup'     =>  'users#new'
  get   '/login',     to: 'sessions#new'
  post  '/login',     to: 'sessions#create'
  post  '/easylogin/:id' =>  'sessions#easylogin'
  get   '/line',      to: 'sessions#line'
  post  '/line',      to: 'sessions#line_connection'
  delete '/logout',   to: 'sessions#destroy'
  post  '/callback'   =>  'linebots#callback'

  get   '/index'      =>  'static_pages#index'
  post  '/index'      =>  'static_pages#index'

  resource :users, only: [:setting] do
    get :setting, on: :member
    # redirect to edit_user_path for line
  end
  resources :users do
    member do
      get :following, :followers, :subscribing, :delete
      # GET /users/1/following
      # GET /users/1/followers
      # GET /users/1/subscribing
      # GET /users/1/delete
    end
  end

  resources :account_deletes, only: [:update] do
    get :exec, on: :member
  end

  concern :likeable do
    resources :likes, only: [:create, :destroy]
    resource  :likes, only: [:show, :close] do
      get :close, on: :member
    end
  end
  
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :relationships,       only: [:create, :destroy, :subscribe, :unsubscribe] do
    patch :subscribe, on: :member
    patch :unsubscribe, on: :member
  end
  resources :microposts,          only: [:create, :destroy, :show, :index], concerns: :likeable do
    resources :comments,  only: [:create, :destroy, :show, :close, :mention_delete] do
      get :close, on: :member
      get :mention_delete, on: :member
    end
  end
  resources :comments,            only: [:show, :close], concerns: :likeable do
    get :close, on: :member
  end
  
  resource :notifications, only: [:notified, :activity] do
    get :notified, on: :member
    get :activity, on: :member
  end
  
end
