json.product do
  json.partial! 'v1/products/base', product: @product

  json.category do
    json.partial! 'v1/categories/base', category: @product.category
  end

  json.variants @product.variants do |variant|
    json.partial! 'v1/variants/base', variant: variant
  end
end
