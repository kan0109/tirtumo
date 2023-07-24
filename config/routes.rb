Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'top#index'
  get 'terms', to: 'top#terms'
  get 'privacy', to: 'top#privacy'
  get 'contact', to: 'top#contact'

  get 'explanation', to: 'explanations#index'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy' 
  get 'my_page', to: 'my_pages#show', as: 'my_page'
  get 'users/index' => 'users#index'
  
  resources :users, only: %i[new create]
  resources :password_resets, only: %i[new create edit update]
  resources :posts do
    resources :comments, only: %i[create destroy], shallow: true
  end
  
  get "like/:id" => "likes#create", as: "create_like"
  delete "like/:id" => "likes#destroy", as: "destroy_like"
  
  get '/likes', to: 'posts#likes', as: 'post_likes'

  resource :profile, only: %i[show edit update]

  resources :records, only: %i[index update]
  resources :targets, only: %i[new create]

  resources :notifications, only: %i[index]
end
