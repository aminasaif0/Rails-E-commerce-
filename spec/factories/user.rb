FactoryBot.define do
    factory :user do
        email { Faker::Internet.email }
        password { 'password123' }
        encrypted_password { Devise::Encryptor.digest(User, password) }
        reset_password_token { nil }
        reset_password_sent_at { nil }
        remember_created_at { nil }
        created_at { Time.current }
        updated_at { Time.current }
        trait :admin do
            role { 'admin' }
        end
    end
end
