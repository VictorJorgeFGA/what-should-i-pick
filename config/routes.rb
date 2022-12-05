Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ('/')
  # root 'articles#index'
  root 'application#home'

  post '/user_lang/:user_lang', to: 'application#change_user_language'

  resources :champions, only: [:index, :show]
  resources :recommendations, except: [:index, :destroy]
end
