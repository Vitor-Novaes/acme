# frozen_string_literal: true

Rails.application.routes.draw do
  root 'health_check/health_check#index', defaults: { format: :json }

  namespace :v1, defaults: { format: :json }, constraints: { format: :json } do
    resources :orders
    resources :clients
    resources :categories, except: %i[show]
    resources :products

    post 'orders/import-data', to: 'orders#import'
  end
end
