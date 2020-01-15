FactoryBot.define do
  factory :notification do
    send_at { Date.today.prev_month }
    read_at { DateTime.now }
    payment_deadline_on { Date.today }
    tax_amount { Faker::Number.decimal(2) }
    period { Faker::Date.forward(23) }
    customer
    sheet
  end
end
