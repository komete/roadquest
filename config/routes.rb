Rails.application.routes.draw do

  root 'pages#acceuil'
  get 'acceuil'      => 'pages#acceuil'
  get 'cartes'       => 'pages#cartes'
  get 'recherches'   => 'pages#recherches'
  get 'offres'       => 'pages#offres'
  get 'dashboard'    => 'pages#dashboard'
  get 'signup'       => 'users#new'
  get 'users/gestion'        => 'users#gestion'
  put 'users/:id'    => 'users#activation'
  get 'login'        => 'sessions#new'
  post 'login'       => 'sessions#create'
  delete 'logout'    => 'sessions#destroy'
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'data/select'  => 'data#select'
  post 'data/import' => 'data#import'
  get 'troncon_routes/select' => 'troncon_routes#select'
  post 'troncon_routes/import' => 'troncon_routes#import'
  get 'marquages/new'
  get 'troncon_routes/travaux/:id' => 'troncon_routes#show_travaux'
  resources :works
  resources :produits, only: [:show, :create, :new]
  resources :marquages
  resources :marquage_lineaires, only: [:show]
  resources :marquage_specialises, only: [:show]
  resources :routes, only: [:index, :show]
  resources :troncon_routes, only: [:select, :index, :import, :show, :show_travaux]
  resources :point_reperes
  resources :users, only: [:new, :create, :edit, :update, :destroy]
  resources :account_verifications, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

end
