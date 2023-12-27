class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details
  has_many :orders, through: :order_details, dependent: :destroy
  has_many :cart_items, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[category_id created_at description id name price stock_quantity updated_at]
  end
end
