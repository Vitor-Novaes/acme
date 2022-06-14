json.categories @categories do |category|
  json.partial! 'v1/categories/base', category: category
end

json.partial! 'v1/partials/paginate', records: @categories
