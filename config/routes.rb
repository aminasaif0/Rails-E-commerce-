Rails.application.routes.draw do
  devise_for :users
  root "products#index"

  resources :products do
    member do
      post 'add_to_cart'
    end
  end
  resources :carts, only: [:show]
end
