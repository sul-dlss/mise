Rails.application.routes.draw do
  root to: 'home#show'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'test', to: 'static#show'
end
