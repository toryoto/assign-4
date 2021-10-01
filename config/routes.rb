Rails.application.routes.draw do
  
  root to: 'homes#top'
  
  devise_for :users
  
  get "/home/about" => "homes#about"
  

  
  resources :books, only: [:create, :index, :show, :destroy, :edit, :update]
  
  resources :users, only: [:show, :edit, :update, :index, :create]
  
end
