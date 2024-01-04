require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:category) { FactoryBot.create(:category) }

  describe 'GET #new' do
    it 'assigns a new category to @category' do
      get :new
      expect(assigns(:category)).to be_a_new(Category)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new category' do
        category_attributes = FactoryBot.attributes_for(:category)
        post :create, params: { category: category_attributes }
        created_category = Category.find_by(name: category_attributes[:name])
        expect(created_category).to be_present
      end

      it 'redirects to root_path' do
        post :create, params: { category: { name: 'Test Category' } }
        expect(response).to redirect_to(root_path)
      end

      it 'sets a flash notice' do
        post :create, params: { category: { name: 'Test Category' } }
        expect(flash[:notice]).to eq('Category was successfully created.')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new category' do
        expect {
        post :create, params: { category: { name: nil } }
        }.to_not change(Category, :count)
      end

      it 'renders the new template' do
        post :create, params: { category: { name: nil } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'private method #category_params' do
    it 'permits only the name parameter' do
      should permit(:name).for(:create, params: { category: { name: 'Test Category' } }).on(:category)
    end
  end
end
