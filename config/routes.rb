Rails.application.routes.draw do
  root 'static_pages#home'
  get   '/home'       =>  'static_pages#home'
  get   '/about'      =>  'static_pages#about'
  get   '/contact'    =>  'static_pages#contact'
  get   '/signup'     =>  'users#new'
  get   '/login',     to: 'sessions#new'
  post  '/login',     to: 'sessions#create'
  post  '/easylogin/:id' =>  'sessions#easylogin'
  get   '/line',      to: 'sessions#line'
  post  '/line',      to: 'sessions#line_connection'
  delete '/logout',   to: 'sessions#destroy'
  get    '/logout',   to: 'sessions#destroy'  # offcanvasのbug対策（post(delete含む)が効かないため）
  post  '/callback'   =>  'linebots#callback'

  resource :help, only: [:show, :googleslides, :powerpoint] do
    get :googleslides, on: :member
    get :powerpoint, on: :member
  end

  resource :users, only: [:setting, :get_selected_school_type] do
    get :setting, on: :member
    get :get_selected_school_type, on: :member
    # redirect to edit_user_path for line
  end
  resources :users do
    member do
      get :following, :followers, :subscribing, :delete, :portcurio
      # GET /users/1/following
      # GET /users/1/followers
      # GET /users/1/subscribing
      # GET /users/1/delete
      # GET /users/1/portcurio
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
  resources :microposts, except: :new, concerns: :likeable do
    get :remove_exist_image, on: :member
    collection do
      get :get_selected_school_type
      get :add_search_tag
      get :remove_image
      resource :files, only: [:new, :set, :close, :remove] do
        get :set,     on: :collection
        get :close,   on: :collection
        get :remove,   on: :collection
      end
    end
    resource :files, only: [:edit, :replace, :remove_exist] do
      get :replace,      on: :collection
      get :remove_exist, on: :collection
    end
    resources :comments, only: [:create, :destroy, :show, :close, :mention_delete] do
      get :close, on: :member
      get :mention_delete, on: :member
    end
    resources :porcs, only: [:create, :destroy]
    resource :tags, only: [:edit, :update]
  end
  resources :comments, only: [:show, :close], concerns: :likeable do
    get :close, on: :member
  end
  
  resource :notifications, only: [:notified, :activity] do
    get :notified, on: :member
    get :activity, on: :member
  end
  
  resource :links, only: [:show, :edit, :create]
end
