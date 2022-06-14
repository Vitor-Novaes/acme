json.products @products do |product|
  json.partial! 'v1/products/base', product: product
end

json.partial! 'v1/partials/paginate', records: @products
