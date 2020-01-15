FactoryBot.define do
  factory :customer do
    email { Faker::Internet.email }
    fullname { Faker::Name.name }
  end
end
