require 'faker'

FactoryBot.define do
  factory :user do |f|
    f.name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    f.email { Faker::Internet.email  }
    f.password { Faker::Internet.password }
  end
end
