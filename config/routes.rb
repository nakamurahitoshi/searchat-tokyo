Rails.application.routes.draw do
  devise_for :users
  root to: "railways#index"
  # 最寄駅検索のためDBにアクセスするメソッド
  get '/stations/search', to: 'stations#search'
  resources :stations, only: [:index, :show] do
    resources :messages, only: [:index, :create, :show]
  end
  resources :railways, only: [:index, :update]
  resources :users, only: [:edit, :update, :create] 
  
end