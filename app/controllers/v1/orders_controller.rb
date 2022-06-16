# frozen_string_literal: true

module V1
  class OrdersController < ApplicationController
    before_action :find_order, only: %i[show update destroy]

    def index
      @orders = if filter_permitted[:status].nil?
                  filter_sort(filter_permitted, Order)
                    .page(params[:page]).per(params[:per_page])
                else
                  filter_sort(filter_permitted, Order)
                    .by_status(filter_permitted).page(params[:page]).per(params[:per_page])
                end

      @orders
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

    def filter_permitted
      params.permit(:by_category, :sort_by_sales, :status)
    end

    def find_order
      @order = Order.find(params[:id])
    end
  end
end
