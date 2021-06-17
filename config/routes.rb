Rails.application.routes.draw do
  root 'user#index'
  devise_for :users
  resources :users, only: %i[index show] do
    resources :friendships, only: %i[create]
  end

  resources :posts, only: %i[index new create destroy] do
    resources :likes, only: %i[create]  
  end

  resources :comments, only: %i[new create destroy] do
    resources :likes, only: %i[create]
  end
end
