Rails.application.routes.draw do
  resources :projects do
    resources :workspaces, except: %i[show destroy edit]
    resources :resources, except: %i[show destroy edit]
  end

  resources :workspaces, only: %i[index show destroy edit update] do
    member do
      get 'duplicate'
      get 'embed'
    end
  end
  resources :resources, only: %i[show destroy edit update]

  mount OkComputer::Engine, at: "/status"

  authenticated do
    root to: 'projects#index'
  end

  root to: 'home#show', as: :landing_page


  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'login', to: 'static#login'
end
