# frozen_string_literal: true

module V1
  class ClientsController < ApplicationController
    before_action :find_client, only: %i[show update destroy]

    def index
      @clients = Client.order(name: params[:order] || :DESC)
                       .page(params[:page])
                       .per(params[:per_page])
    end

    def show; end

    def create
      client = Client.create!(permitted_params)

      render json: client, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors }, status: :unprocessable_entity
    end

    def update
      @client.update!(permitted_params)

      render json: find_client, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors }, status: :unprocessable_entity
    end

    def destroy
      @client.destroy
    end

    private

    def permitted_params
      params.permit(:email, :name)
    end

    def find_client
      @client = Client.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :not_found
    end
  end
end
