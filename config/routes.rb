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
  get 'like/:id' => 'likes#create', as: 'create_like'
  delete 'like/:id' => 'likes#destroy', as: 'destroy_like'

  get '/likes', to: 'posts#likes', as: 'post_likes'

  resources :users, only: %i[index new create]
  resources :password_resets, only: %i[new create edit update]
  resource :my_page, only: %i[show]
  resources :posts do
    resources :comments, only: %i[create destroy], shallow: true
  end
  resource :profile, only: %i[show edit update]
  resources :records, only: %i[index update]
  get 'reset_records', to: 'records#reset_records', as: :reset_records
  resources :targets, only: %i[new create]
  resources :notifications, only: %i[index]
end