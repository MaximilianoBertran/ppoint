FactoryBot.define do
  factory :category do |f|
    f.name { Faker::Commerce.department }

    after :create do |category|
      create_list :product, 20, category: Category.all
    end
  end
end
