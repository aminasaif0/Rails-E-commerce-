class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items

  def add_product(product)
    cart_items.create(product: product, quantity: 1)
  end
end
