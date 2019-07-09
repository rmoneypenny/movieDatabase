Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#show'
  resources :users, only: [:new, :create]

  resources :movies, only: [:index, :show]

  get 'searchMovies', to: 'movies#searchMovies'
  post 'searchMovies', to: 'movies#searchMovies'

  get 'settings', to: 'users#settings'

  post 'login', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'
  
end
