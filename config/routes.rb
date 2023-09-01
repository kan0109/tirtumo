Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'omniauth_callbacks'
  }

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'top#index'
  get 'terms', to: 'top#terms'
  get 'privacy', to: 'top#privacy'
  get 'contact', to: 'top#contact'

  get 'search' => 'posts#search'

  resources :users, only: %i[index new create show]
  resources :password_resets, only: %i[new create edit update]
  resource :my_page, only: %i[show]
  resources :posts do
    resources :comments, only: %i[create destroy], shallow: true
    member do
      get :likes
    end
  end
  resources :likes, only: %i[create destroy]
  resource :profile, only: %i[show edit update]
  resources :records, only: %i[index update]
  get 'reset_records', to: 'records#reset_records', as: :reset_records
  resources :targets, only: %i[new create edit update]
  resources :notifications, only: %i[index]
  resources :savings_items, only: %i[new create edit update]
end
