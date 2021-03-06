Rails.application.routes.draw do
  resources :projects, except: %i[new edit] do
    resources :workspaces, only: %i[index create]

    resources :annotations, except: %i[new edit], defaults: { format: :json } do
      collection do
        get 'lists'
        get 'pages'
      end
    end

    resources :resources, except: %i[destroy edit] do
      collection do
        get 'iiif', defaults: { format: :json }
      end
    end

    resources :roles, only: %i[index create update destroy]
  end

  resources :workspaces, except: :new do
    member do
      post 'favorite'
      get 'embed'
      get 'viewer'
    end
  end
  resources :resources, only: %i[show destroy edit update]

  mount OkComputer::Engine, at: "/status"

  authenticated do
    root to: 'home#dashboard'
    get 'explore', to: 'home#explore'
  end

  authenticate :user, lambda { |u| u.has_role? :superadmin } do
    require 'sidekiq/web'
    require 'sidekiq/pro/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'home#public', as: :landing_page

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
