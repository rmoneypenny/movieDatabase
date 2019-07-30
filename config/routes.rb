Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#show'
  resources :users, only: [:new, :create]

  resources :movies, only: [:index, :show]
  resources :reviews, only: [:create, :show, :index, :edit, :update, :destroy]

  get 'searchReviews', to: 'reviews#searchReviews'
  post 'searchReviews', to: 'reviews#searchReviews'

  get 'searchMovies', to: 'movies#searchMovies'
  post 'searchMovies', to: 'movies#searchMovies'

  get 'settings', to: 'users#settings'
  get 'settings/editReviews', to: 'reviews#loggedInUserReviews'
  get 'settings/editUser', to: 'users#editUser'
  patch 'settings/editUser', to: 'users#update'
  patch 'settings/updatePassword', to: 'users#updatePassword'

  post 'login', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'
  
end
