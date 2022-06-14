# frozen_string_literal: true

module V1
  class ProductsController < ApplicationController
    before_action :find_product, only: %i[show update destroy]

    def index
      @products = Product.order(created_at: params[:sort] || :DESC)
                         .page(params[:page])
                         .per(params[:per_page])
    end

    def show; end

    def create
      product = Product.create!(permitted_params)

      render json: product, status: :ok
    end

    def update
      @product.update!(permitted_params)

      render json: @product, status: :ok
    end

    def destroy
      @product.destroy
    end

    private

    def permitted_params
      params.permit(
        :base_value,
        :name,
        :category_id,
        variants_attributes: %i[id code value image _destroy]
      )
    end

    def find_product
      @product = Product.find(params[:id])
    end
  end
end
