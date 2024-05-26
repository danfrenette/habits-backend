Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:create], param: :clerk_id do
      resources :habits, only: [:index, :create]
      resources :tasks, only: [:create, :update, :index]
    end

    resources :tasks, only: [:update]
  end
end
