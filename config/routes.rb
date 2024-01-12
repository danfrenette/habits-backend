Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:create] do
      resources :habits, only: [:index, :create]
    end
  end
end
