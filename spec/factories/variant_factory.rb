# frozen_string_literal: true

FactoryBot.define do
  factory :variant, class: Variant do
    code { Faker::Number.number(digits: 10) }
    value { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    image { Faker::Internet.url }
    sales { Faker::Number.number(digits: 2) }
    product factory: :product
  end
end
