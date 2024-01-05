require 'rails_helper'

RSpec.describe ProductsController, type: :controller do

  let(:category) { FactoryBot.create(:category) }
  let(:product) { FactoryBot.create(:product) }
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
        product_attributes = FactoryBot.attributes_for(:product, category_id: category.id)
        post :create, params: { product: product_attributes }
        created_product = Product.find_by(name: product_attributes[:name])
        expect(created_product).to be_present
      end

      it 'sets the correct name for the created product' do
        product_attributes = FactoryBot.attributes_for(:product, category_id: category.id)
        post :create, params: { product: product_attributes }
        last_created_product = Product.find_by(name: product_attributes[:name])
        expect(last_created_product.name).to eq(product_attributes[:name])
      end

      it 'set correct category for the created product' do
        product_attributes = FactoryBot.attributes_for(:product, category_id: category.id)
        post :create, params: { product: product_attributes }
        last_created_product = Product.find_by(name: product_attributes[:name])
        category_name = Category.find_by(id: product_attributes[:category_id]).name
        expect(last_created_product.category.name).to eq(category_name)
      end

      it 'redirects to the created product' do
        product_attributes = FactoryBot.attributes_for(:product, category_id: category.id)
        post :create, params: { product: product_attributes }
        created_product = Product.find_by(name: product_attributes[:name])
        expect(response).to redirect_to(created_product)
      end
    end

    context 'with invalid attributes' do
      it 'renders the new template with errors' do
        post :create, params: { product: FactoryBot.attributes_for(:product, name: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
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
        product_attributes = FactoryBot.attributes_for(:product, category_id: category.id)
        put :update, params: { id: product.id, product: { name: product_attributes[:name] } }
        updated_product = Product.find_by(name: product_attributes[:name])
        expect(updated_product.reload.name).to eq(product_attributes[:name])
      end

      it 'redirects to the updated product' do
        product_attributes = FactoryBot.attributes_for(:product, category_id: category.id)
        put :update, params: { id: product.id, product: { name: product_attributes[:name] } }
        updated_product = Product.find_by(name: product_attributes[:name])
        expect(response).to redirect_to(updated_product)
      end
    end
    context 'with invalid attributes' do
      it 'renders the edit template with errors' do
        put :update, params: { id: product.id, product: { name: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
        expect(assigns(:product).errors).not_to be_empty
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the product' do
      product
      Product.__elasticsearch__.refresh_index!
      expect{
        delete :destroy, params: {id: product.id}
      }.to change { Product.exists?(product.id) }.from(true).to(false)
    end

    it 'redirects to the products list' do
      delete :destroy, params: { id: product.id }
      expect(response).to redirect_to(products_url)
    end
  end

  describe 'POST #add_to_cart' do
    it 'creates a cart for the user if it does not exist' do
      expect {
        post :add_to_cart, params: { id: product.id }
      }.to change { user.reload.cart.present? }.from(false).to(true)
    end

    it 'adds the product to the user\'s cart' do
      post :add_to_cart, params: { id: product.id }
      expect(user.cart.cart_items.map(&:product)).to include(product)
    end

    it 'redirects to products_path with a notice' do
      post :add_to_cart, params: { id: product.id }
      expect(response).to redirect_to(products_path)
      expect(flash[:notice]).to eq('Product added to cart.')
    end
  end

  describe 'GET #autocomplete' do
    let!(:product1) { create(:product) }
    let!(:product2) { create(:product) }
    it 'returns a JSON response with product name suggestions' do
      get :autocomplete, params: { term: product1.name[0,2] }
      json_response = JSON.parse(response.body)
      expect(response).to be_successful
      expect(json_response).to include(product1.name)
    end

    it 'returns an empty JSON array for no matching suggestions' do
      get :autocomplete, params: { term: 'XYZ' }

      json_response = JSON.parse(response.body)
      expect(response).to be_successful
      expect(json_response).to eq([])
    end
  end
end
