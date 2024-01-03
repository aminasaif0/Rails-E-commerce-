require 'rails_helper'

RSpec.describe Role, type: :model do
    describe 'associations' do
        it { should have_many(:users).through(:roles_users) }
        it { should have_many(:roles_users).dependent(:destroy) }
    end
end
