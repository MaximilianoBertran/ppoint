require 'faker'

FactoryBot.define do
  factory :product do |f|
    association :category
    f.name { Faker::App.name }
    f.brand { Faker::Appliance.brand  }
    f.units { Faker::Number.between(from: 10, to: 100) }
    f.vendor { Faker::App.name }
    f.price { Faker::Commerce.price }

    after :create do |product|
      create_list :purchase, Faker::Number.between(from: 1, to: 5), product: product, user: User.last
    end
  end
end
