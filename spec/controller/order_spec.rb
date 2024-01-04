require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category) }
  let(:product) { FactoryBot.create(:product, category: category) }

  before do
    sign_in user
  end
  describe 'GET #show' do
    let(:order) { create(:order, user: user) }

    it 'renders the show template' do
      get :show, params: { id: order.id }

      expect(response).to render_template(:show)
      expect(assigns(:order)).to eq(order)
    end
  end
  describe 'POST #create' do
    it 'creates a new order' do
      post :create, params: { order: attributes_for(:order) }

      expect(response).to redirect_to(products_path)
      expect(flash[:notice]).to eq('Order successfully placed.')
    end

    it 'fails to create an order' do
      post :create, params: { order: { invalid_param: 'invalid' } }

      expect(response).to redirect_to(products_path)
      expect(flash[:alert]).to eq('Order creation failed.')
    end
  end
end
