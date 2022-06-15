json.order do
  json.partial! 'v1/orders/base', order: @order

  json.client do
    json.partial! 'v1/clients/base', client: @order.client
  end

  json.products @order.registers do |register|
    json.quantity register.quantity
    json.product do
      json.partial! 'v1/products/base', product: register.product
      json.variant do
        json.partial! 'v1/variants/base', variant: register.variant
      end
    end
  end
end
