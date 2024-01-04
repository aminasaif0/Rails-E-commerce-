FactoryBot.define do
  factory :product do
    transient do
      unique_name { Faker::Name.unique.name }
    end

    name { unique_name }
    description { 'A sample product description.' }
    price { 19.99 }
    category
    stock_quantity { 10 }

  end
end
