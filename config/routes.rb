Rails.application.routes.draw do
  devise_for :users
  root to: "railways#index"
  resources :stations, only: [:index, :show] do
    resources :messages, only: [:index, :create, :show]
  end
  resources :railways, only: :index
  resources :users, only: [:edit, :update] 
end