require 'rails_helper'

RSpec.describe ProductsController, type: :controller do

  let(:category) { FactoryBot.create(:category) }
  let(:product) { FactoryBot.create(:product, category: category) }
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { id: product.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new product' do
        expect {
          post :create, params: { product: FactoryBot.attributes_for(:product, category_id: category.id) }
        }.to change(Product, :count).by(1)
      end

      it 'sets the correct name for the created product' do
        post :create, params: { product: FactoryBot.attributes_for(:product, category_id: category.id) }
        last_created_product = Product.last
        expect(last_created_product.name).to eq('Sample Product')
      end

      it 'set correct category for the created product' do
        post :create, params: { product: FactoryBot.attributes_for(:product, category_id: category.id) }
        last_created_product = Product.last
        expect(last_created_product.category.name).to eq('car')
      end

      it 'redirects to the created product' do
        post :create, params: { product: FactoryBot.attributes_for(:product, category_id: category.id) }
        expect(response).to redirect_to(Product.last)
      end
    end

    context 'with invalid attributes' do
      it 'renders the new template with errors' do
        post :create, params: { product: FactoryBot.attributes_for(:product, name: nil) }
        expect(response).to render_template(:index)
        expect(assigns(:product).errors).not_to be_empty
      end
    end
  end

  describe 'GET #edit' do
    it 'renders the edit template' do
      get :edit, params: { id: product.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it 'updates the product' do
        new_name = 'Updated Name'
        put :update, params: { id: product.id, product: { name: new_name } }
        updated_product = product.reload
        expect(updated_product.reload.name).to eq(new_name)
      end

      it 'redirects to the updated product' do
        put :update, params: { id: product.id, product: { name: 'Updated Name' } }
        expect(response).to redirect_to(product)
      end
    end
    context 'with invalid attributes' do
      it 'renders the edit template with errors' do
        put :update, params: { id: product.id, product: { name: nil } }
        expect(response).to render_template(:edit)
        expect(assigns(:product).errors).not_to be_empty
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the product' do
      product
      sleep 1
      expect{
        delete :destroy, params: {id: product.id}
      }.to change { Product.exists?(product.id) }.from(true).to(false)
    end

    it 'redirects to the products list' do
      delete :destroy, params: { id: product.id }
      expect(response).to redirect_to(products_url)
    end
  end
end
