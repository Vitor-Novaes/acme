json.orders @orders do |order|
  json.partial! 'v1/orders/base', order: order
end

json.partial! 'v1/partials/paginate', records: @orders
