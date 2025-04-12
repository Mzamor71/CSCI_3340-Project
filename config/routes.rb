Rails.application.routes.draw do
  get 'my_watchlist', to: 'watchlist_items#my_watchlist', as: :my_watchlist
  
  # Fix the devise_for line - remove the only: [:show]
  devise_for :users
  
  # Add this if you want user profiles later
  resources :users, only: [:show]
  
  resources :watchlist_items
  resources :comments
  resources :ratings
  resources :genres
  resources :movies do
    resources :ratings
    resources :reviews, only: [:new, :create]
    resources :watchlist_items, only: [:create, :destroy]
  end

  # The rest of your routes remain the same
  get "up" => "rails/health#show", as: :rails_health_check
  get '/search', to: 'search#index'

  resources :ratings, only: [:show] do
    resources :comments, only: [:create]
  end

  resources :comments do
    member do
      post 'like'
    end
  end

  root "movies#index"
end