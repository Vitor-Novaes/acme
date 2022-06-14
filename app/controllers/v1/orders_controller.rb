# frozen_string_literal: true

module V1
  class OrdersController < ApplicationController
    before_action :find_order, only: %i[show update destroy]

    def index
      @orders = Order.order(created_at: params[:sort] || :DESC)
                     .page(params[:page])
                     .per(params[:per_page])
    end

    def show; end

    def create
      order = Order.create!(permitted_params)

      render json: order, status: :ok
    end

    def update
      @order.update!(update_permitted_params)

      render json: @order, status: :ok
    end

    def destroy
      @order.destroy
    end

    private

    def permitted_params
      # TODO products: []
      params.permit(:status, :address, :city, :state, :payment_date, :code, :client_id, :net_value)
    end

    def update_permitted_params
      params.permit(:status, :payment_date)
    end

    def find_order
      @order = Order.find(params[:id])
    end
  end
end
