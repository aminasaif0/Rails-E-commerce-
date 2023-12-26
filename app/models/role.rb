class Role < ApplicationRecord
    has_many :users
    has_many :roles_users, dependent: :destroy
end
