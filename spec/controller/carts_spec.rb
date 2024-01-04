require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  describe 'GET #show' do
    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:cart) { create(:cart, user: user) }
      let(:product) { create(:product) }
      let!(:cart_item) { create(:cart_item, cart: cart, product: product) }

      before do
        sign_in user
        get :show
      end

      it 'assigns the cart and cart items' do
        expect(assigns(:cart)).to eq(cart)
        expect(assigns(:cart_items)).to include(cart_item)
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to the sign-in page' do
        get :show
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
