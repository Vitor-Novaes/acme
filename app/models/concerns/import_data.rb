
# rubocop:disable all
module ImportData
  extend ActiveSupport::Concern
  FILE_FORMATS = %w[text/csv].freeze

  def csv_file(file)
    raise('The file must be CSV type') unless FILE_FORMATS.include?(file.content_type)

    csv = Roo::CSV.new(file, csv_options: { col_sep: ',', encoding: 'bom|utf-8' })
    rows = csv.sheet(0)
    sucess = 0
    fails = 0
    message = []

    rows.each.with_index do |row, index|
      next if index < 1

      begin
        @row = row
        @client = create_client
        @category = create_category
        @product = create_product
        @variant = create_variant
        create_order

        p @row
        p "______________________________________________"
        sucess += 1
      rescue StandardError => e
        fails += 1
        message << "#{index}: #{e}"
        next
      end
    end

    p "Sucess lines: #{sucess}"
    p "Fails lines: #{fails}"
    p "Messages #{message}"
  end

  private

  def create_client
    Client.where(email: cell('client_email'))
          .first_or_create({
                             email: cell('client_email'),
                             name: cell('client_name')
                           })
  end

  def create_category
    Category.where(name: cell('category_name'))
            .first_or_create({
                               name: cell('category_name')
                             })
  end

  def create_product
    Product.where(name: cell('product_name'))
           .first_or_create({
                              category: @category,
                              name: cell('product_name'),
                              base_value: cell('product_base_value')
                            })
  end

  def create_variant
    results = Variant.where(code: variant_code)
                     .where(product_id: @product.id)
    if results.empty?
      Variant.create({
                      product: @product,
                      sales: 1,
                      code: variant_code,
                      value: cell('variant_value'),
                      image: cell('variant_image')
                    })
    else
      results.first.update!(sales: results.first.sales + 1)
      results.first
    end
  end

  def variant_code
    cell('variant_image').split('/').last(3).first
  end

  def create_order
    result = Order.where(code: cell('order_code'))
    if result.empty?
      register = Register.create({
        product: @product,
        variant: @variant,
        quantity: 1
      })
      Order.create({
          code: cell('order_code'),
          payment_date: cell('order_payment_date'),
          status: cell('order_status').upcase,
          address: cell('order_address'),
          state: cell('order_state'),
          city: cell('order_city'),
          net_value: cell('order_net_value'),
          client: @client,
          registers: [register]
        })
    else
      order = result.first
      register = Register
                        .where(variant_id: @variant.id)
                        .where(product_id: @product.id)

      if register.empty?
        Register.create({
          product: @product,
          variant: @variant,
          quantity: 1,
          order: order
        })
      else
        register.first.update!({
          quantity: register.first.quantity + 1
        })
        register.first.variant.update!(sales: register.first.variant.sales + 1)
      end
    end
  end

  def cell(key)
    map = {
      order_code: 0,
      client_email: 1,
      order_payment_date: 2,
      client_name: 3,
      order_status: 4,
      order_net_value: 5,
      variant_value: 6,
      variant_image: 7,
      product_name: 8,
      category_name: 9,
      product_base_value: 10,
      order_city: 11,
      order_state: 12,
      order_address: 13
    }

    @row.at(map[key.to_sym])
  end
end

# rubocop:enable all
