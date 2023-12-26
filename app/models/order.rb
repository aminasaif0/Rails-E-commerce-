class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details
  has_many :products, through: :order_details
  belongs_to :user

  validates :first_name, :last_name, :email, :address, :phone_number, :province, presence: true

end
