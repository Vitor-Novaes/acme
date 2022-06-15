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

    def import
      Order.new.import_data(import_params)

      render json: { message: 'successfully imported' }
    end

    private

    def permitted_params
      params.permit(
        :status, :address,
        :city, :state,
        :payment_date, :code,
        :client_id, :net_value,
        registers_attributes: %i[quantity product_id variant_id]
      )
    end

    def update_permitted_params
      params.permit(:status, :payment_date)
    end

    def import_params
      params.require(:file)
    end

    def find_order
      @order = Order.find(params[:id])
    end
  end
end
