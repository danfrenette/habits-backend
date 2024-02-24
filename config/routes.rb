Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:create] do
      resources :habits, only: [:index, :create]
      resources :tasks, only: [:create]
    end

    resources :tasks, only: [:index, :update]
  end
end
