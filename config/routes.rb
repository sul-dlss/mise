Rails.application.routes.draw do
  resources :resources do
    member do
      get 'new' => 'resources#new', as: :new_contained
    end
  end

  mount OkComputer::Engine, at: "/status"

  authenticated do
    root to: 'resources#index'
  end

  root to: 'home#show', as: :landing_page


  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'test', to: 'static#show'
  get 'login', to: 'static#login'
end
