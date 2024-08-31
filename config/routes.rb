require "sidekiq/web"

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_your_app_session"

Rails.application.routes.draw do
  if Rails.env.production?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
    end
  end

  mount Sidekiq::Web => "/sidekiq"
  namespace :api do
    resources :users, only: [:create], param: :clerk_id do
      resources :habits, only: [:index, :create]
      resources :tasks, only: [:create, :index, :show]
      resources :task_completions, only: [:index]
    end

    resources :tasks, only: [:update, :destroy]
    resources :task_completions, only: [:update]
  end
end
