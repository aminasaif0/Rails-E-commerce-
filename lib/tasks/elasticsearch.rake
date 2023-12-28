namespace :elasticsearch do
  desc "Import all products into Elasticsearch"
  task import_products: :environment do
    Product.import
  end
end
