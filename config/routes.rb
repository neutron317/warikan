Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    resources :groups, only: [ :index, :create, :show ] do
      resources :members, only: [ :index, :create ]
      resources :payments, only: [ :index, :create ]
    end
  end
end
