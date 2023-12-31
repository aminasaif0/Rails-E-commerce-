require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { should belong_to(:category) }
    it { should have_many(:order_details) }
    it { should have_many(:orders).through(:order_details).dependent(:destroy) }
    it { should have_many(:cart_items).dependent(:destroy) }
  end

  describe 'callbacks' do
    it 'triggers update_elastic_search_index after commit on create' do
      product = build(:product)
      expect(product).to receive(:update_elastic_search_index)
      product.save!
    end

    it 'triggers update_elastic_search_index after commit on update' do
      product = create(:product)
      expect(product).to receive(:update_elastic_search_index)
      product.update!(name: 'Updated Product')
    end
  end

  describe 'searchkick configuration' do
    it 'has searchkick word start option for :name' do
      expect(Product.searchkick_options[:word_start]).to include(:name)
    end

    it 'has searchkick suggest option for :name' do
      expect(Product.searchkick_options[:suggest]).to include(:name)
    end
  end

  describe 'elasticsearch methods' do
    let(:product) { create(:product) }

    it 'calls index_document on Elasticsearch after commit' do
      expect(product.__elasticsearch__).to receive(:index_document)
      product.save!
    end

    it 'provides search_data for Elasticsearch' do
      expect(product.search_data).to eq({ name: product.name })
    end

    it 'configures Elasticsearch settings and mappings' do
      elasticsearch_client = Product.__elasticsearch__.client
      index_settings = elasticsearch_client.indices.get_settings(index: Product.index_name)
      mappings = elasticsearch_client.indices.get_mapping(index: Product.index_name)

      expect(index_settings[Product.index_name]['settings']['index']['number_of_shards']).to eq('1')
      expect(mappings[Product.index_name]['mappings']['dynamic']).to eq('false')
      expect(mappings[Product.index_name]['mappings']['properties']['name']['analyzer']).to eq('english')
      expect(mappings[Product.index_name]['mappings']['properties']['description']['analyzer']).to eq('english')
    end
  end
end
