Rails.application.routes.draw do
  get 'orders/new'
  get 'orders/create'
  devise_for :users
  root "products#index"

  resources :products do
    member do
      post 'add_to_cart'
    end
    collection do
      get 'autocomplete'
    end
  end
  resources :carts, only: [:show]
  resources :cart_items, only: [:destroy]
  resources :users, only: [:index]
  resources :orders do
    collection do
      get 'admin_index'
      get 'most_ordered_product'
    end
  end
  resources :categories, only: [:new, :create]
end
