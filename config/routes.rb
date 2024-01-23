Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      resources :customers do
        resources :subscriptions, only: [:index, :destroy]
      end
      # resources :backgrounds, only: [:index]

      post "/customers" => "customers#create"
      # get "/subscriptions" => "subscriptions#index"
      post "/subscriptions" => "subscriptions#create"
    end
  end
end
