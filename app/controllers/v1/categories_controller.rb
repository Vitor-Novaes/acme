# frozen_string_literal: true

module V1
  class CategoriesController < ApplicationController
    before_action :find_category, only: %i[show update destroy]

    def index
      @categories = Category.order(created_at: params[:sort] || :DESC)
    end

    def create
      category = Category.create!(permitted_params)

      render json: category, status: :ok
    end

    def update
      @category.update!(permitted_params)

      render json: @category, status: :ok
    end

    # TODO at least for now
    def destroy
      @category.destroy
    end

    private

    def permitted_params
      params.permit(:name)
    end

    def find_category
      @category = Category.find(params[:id])
    end
  end
end
