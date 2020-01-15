FactoryBot.define do
  factory :sheet do
    sheet_id { Faker::Number.number(10).to_i }
    title { 'title sheet' }
  end
end
