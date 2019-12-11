Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: "railways#index"
  # 最寄駅検索のためDBにアクセスするメソッド
  get '/stations/search', to: 'stations#search'
  # 非同期で駅をお気に入り登録するためのルーティング(deviseのuserとかち合うため、URIを変更)
  get '/users/create', to: 'users#create'
  resources :stations, only: [:index, :show] do
    resources :messages, only: [:index, :create, :show, :destroy]
  end
  resources :railways, only: [:index, :update]
  resources :users, only: [:edit, :update, :create] 
  
end