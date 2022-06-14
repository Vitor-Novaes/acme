# frozen_string_literal: true

FactoryBot.define do
  factory :register, class: Register do
    product factory: :product
    variant factory: :variant
    order factory: :order
    quantity { Faker::Number.within(range: 1..10) }
  end
end
