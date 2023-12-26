Rails.application.routes.draw do
  get 'orders/new'
  get 'orders/create'
  devise_for :users
  root "products#index"

  resources :products do
    member do
      post 'add_to_cart'
      delete 'destroy'
    end
  end
  resources :carts, only: [:show]
  resources :cart_items, only: [:destroy]
  resources :users, only: [:index]
  resources :orders, only: [:new, :create, :show]
  resources :categories, only: [:new, :create]
end
