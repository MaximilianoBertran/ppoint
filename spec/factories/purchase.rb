FactoryBot.define do
  factory :purchase do |f|
    association :user
    association :product
    f.units { Faker::Number.between(from: 1, to: 10) }
    f.amount { product.price * Faker::Number.between(from: 1, to: 10) }
  end
end
