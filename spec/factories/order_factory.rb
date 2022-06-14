# frozen_string_literal: true

FactoryBot.define do
  factory :order, class: Order do
    code { Faker::Number.number(digits: 12) }
    payment_date { Faker::Date.in_date_period }
    status { %w[SENT WAITING PRODUCTION CANCELED POSTING].sample }
    state { Faker::Address.state }
    address { Faker::Address.street_name }
    city { Faker::Address.city }
    net_value { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    client factory: :client

    trait :with_registers do
      transient do
        register_count { 1 }
      end

      after(:create) do |product, evaluator|
        register_count.times do
          create(:register, order: order)
        end
      end
    end
  end
end
