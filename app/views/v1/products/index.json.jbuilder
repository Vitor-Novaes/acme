json.products @products do |product|
  json.partial! 'v1/products/base', product: product
  json.total_sales product.total_sales
end

json.partial! 'v1/partials/paginate', records: @products
