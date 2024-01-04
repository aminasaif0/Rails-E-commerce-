FactoryBot.define do
  factory :order do
    association :user
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    address { Faker::Address.street_address }
    phone_number { Faker::PhoneNumber.phone_number }
    province { Faker::Address.state }
  end
end
