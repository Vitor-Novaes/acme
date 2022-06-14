FactoryBot.define do
  factory :product, class: Product do
    base_value { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    name { Faker::Lorem.sentence(word_count: 5) }
    category factory: :category

    trait :with_variants do
      transient do
        variant_count { 5 }
      end

      after(:create) do |product, evaluator|
        create_list(:variant, evaluator.variant_count, product: product)
      end
    end
  end
end
