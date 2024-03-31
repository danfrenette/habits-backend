Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:create] do
      resources :habits, only: [:index, :create]
      resources :tasks, only: [:index, :create]
    end

    resources :tasks, only: [:update]
  end
end
