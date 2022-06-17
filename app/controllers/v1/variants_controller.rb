# frozen_string_literal: true

module V1
  class VariantsController < ApplicationController
    def index
      @variants = filter_sort(filter_permitted, Variant)
                  .page(params[:page])
                  .per(params[:per_page])
    end

    private

    def filter_permitted
      params.permit(:sort_by_sales, :by_category)
    end
  end
end
