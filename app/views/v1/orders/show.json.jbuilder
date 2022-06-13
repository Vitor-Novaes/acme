json.order do
  json.partial! 'v1/orders/base', order: @order

  json.client do
    json.partial! 'v1/clients/base', client: @order.client
  end
end
