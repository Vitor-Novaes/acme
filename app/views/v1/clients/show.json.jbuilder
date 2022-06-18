json.client do
  json.partial! 'v1/clients/base', client: @client

  json.orders @client.orders do |order|
    json.partial! 'v1/orders/base', order: order
  end
end
