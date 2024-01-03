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

      expect {
        cart.add_product(product)
      }.to change(CartItem, :count).by(1)
      last_cart = cart.cart_items.last
      expect(last_cart.product).to eq(product)
      expect(last_cart.last.quantity).to eq(1)
    end
  end
end
