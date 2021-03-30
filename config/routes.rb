Rails.application.routes.draw do
  mount OkComputer::Engine, at: "/status"

  root to: 'home#show'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'test', to: 'static#show'
  get 'login', to: 'static#login'
end
