class Product < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  require 'redis'

  belongs_to :category
  has_many :order_details
  has_many :orders, through: :order_details, dependent: :destroy
  has_many :cart_items, dependent: :destroy

  after_commit on: [:create, :update] do
    Product.__elasticsearch__.index_document
  end
  searchkick word_start: [:name], suggest: [:name]

  def search_data
  {
    name: name
  }
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[category_id created_at description id name price stock_quantity updated_at]
  end

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :name, analyzer: 'english'
      indexes :description, analyzer: 'english'
    end
  end

  def self.autocomplete_suggestions(query)
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
