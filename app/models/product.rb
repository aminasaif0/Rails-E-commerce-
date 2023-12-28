class Product < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :category
  has_many :order_details
  has_many :orders, through: :order_details, dependent: :destroy
  has_many :cart_items, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[category_id created_at description id name price stock_quantity updated_at]
  end

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :name, analyzer: 'english'
      indexes :description, analyzer: 'english'
    end
  end

  def as_indexed_json(_options = {})
    as_json(only: %i[name description category_id price stock_quantity])
  end

  def self.search(query)
    search_params = {
      query: {
        match: {
          name: {
            query: query,
            fuzziness: 'AUTO'
          }
        }
      }
    }
    __elasticsearch__.search(search_params).records
  end
end
