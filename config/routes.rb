Rails.application.routes.draw do
  
  root 'pages#index'
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :songs
  resources :votes, only: [:new, :create, :destroy]
  match '/register', to: 'users#new', via: 'get'
  match '/login', to: 'sessions#new', via: 'get'
  match '/logout', to: 'sessions#destroy', via: 'delete'
  match '/auto', to: 'pages#autopopulate', via: 'get'
  match '/vote', to: 'votes#new', via: 'get'
  match '/results', to: 'pages#results', via: 'get'
  match '/add_votes', to: 'pages#add_votes', via: 'get'
  post "/playlist" => "pages#playlist"

end