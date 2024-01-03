require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:order_details) }
    it { should have_many(:products).through(:order_details) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_presence_of(:province) }
  end
end
