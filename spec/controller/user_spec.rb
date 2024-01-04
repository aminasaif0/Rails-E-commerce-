require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    let!(:admin_role) { create(:role, name: 'admin') }
    let(:admin_user) { create(:user, :admin) }
    let(:regular_user) { create(:user) }

  describe 'GET #index' do
    context 'when user is an admin' do

      before do
        sign_in admin_user
        get :index
      end

      it 'assigns @users with users including roles' do
        expect(assigns(:users)).to eq(User.includes(:roles))
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end

    end

    context 'when user is not an admin' do
      before do
        sign_in regular_user
        get :index
      end
      it 'redirects to root_path with an alert message' do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Access denied.')
      end
    end
  end
end
