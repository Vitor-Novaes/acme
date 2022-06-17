module SearchTerm
  extend ActiveSupport::Concern

  def filter_sort(params, resource)
    @query = ''
    @resource = resource

    @query << 'sort_by_sales_' if params.include?(:sort_by_sales)
    @query << 'by_category_' if params.include?(:by_category)

    sort_resource(params)
  end

  private

  def sort_resource(params)
    map = {
      by_category_: @resource.by_category(params),
      sort_by_sales_: @resource.sort_by_sales(params),
      sort_by_sales_by_category_: @resource.sort_by_sales(params).by_category(params)
    }

    return @resource.all if @query.empty?

    map[@query.to_sym]
  end
end
