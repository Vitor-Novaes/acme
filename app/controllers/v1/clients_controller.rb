# frozen_string_literal: true

module V1
  class ClientsController < ApplicationController
    before_action :find_client, only: %i[show update destroy]

    def index
      @clients = Client.order(created_at: params[:sort] || :DESC)
                       .page(params[:page])
                       .per(params[:per_page])
    end

    def show; end

    def create
      client = Client.create!(permitted_params)

      render json: client, status: :ok
    end

    def update
      @client.update!(permitted_params)

      render json: find_client, status: :ok
    end

    # TODO at least for now
    def destroy
      @client.destroy
    end

    private

    def permitted_params
      params.permit(:email, :name)
    end

    def find_client
      @client = Client.find(params[:id])
    end
  end
end
