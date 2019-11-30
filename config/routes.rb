Rails.application.routes.draw do
  devise_for :users
  root to: "railways#index"
  resources :stations, only: [:index, :show] do
    resources :messages, only: [:index, :create, :show]
  end
  resources :railways, only: [:index, :update]
  resources :users, only: [:edit, :update, :create] 
end