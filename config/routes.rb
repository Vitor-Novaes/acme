# frozen_string_literal: true

Rails.application.routes.draw do
  root 'health_check/health_check#index', defaults: { format: :json }

  namespace :v1, defaults: { format: :json }, constraints: { format: :json } do
    resources :orders, only: %i[update show destroy index]
    resources :clients, only: %i[update show destroy index]
  end
end
