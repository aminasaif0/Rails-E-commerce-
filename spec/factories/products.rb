FactoryBot.define do
  factory :product do
    name { 'Sample Product' }
    description { 'A sample product description.' }
    price { 19.99 }
    association :category
    stock_quantity { 10 }
  end
end
