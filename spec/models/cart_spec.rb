require 'rails_helper'
require 'faker'

RSpec.describe Cart, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:cart_items) }
  end

  describe '#add_product' do
    let(:user) { create(:user) }

    it 'adds a product to the cart' do
      cart = create(:cart, user: user)
      product = create(:product)

      product = create(:product)
      cart_product = cart.add_product(product)

      expect(cart.cart_items.map(&:product)).to include(product)

      last_cart = cart.cart_items.last
      expect(last_cart.product).to eq(product)
    end
  end
end
