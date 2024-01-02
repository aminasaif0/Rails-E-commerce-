class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  include Pundit::Authorization

  def index
    @q = params[:q]
    @products = @q.present? ? Product.search(@q) : Product.all.page(params[:page]).per(5)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully destroyed.'
  end

  def add_to_cart
    @product = Product.find_by(params[:id])
    current_user.create_cart if current_user.cart.nil?
    current_user.cart.add_product(@product)
    redirect_to products_path, notice: 'Product added to cart.'
  end

  def autocomplete
    query = params[:term]
    suggestions = Product.search(query, fields: [:name], match: :word_start, suggest: true)
    render json: suggestions.map(&:name) and return
  end

  private
  def set_product
    @product = Product.find_by(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :category_id, :stock_quantity)
  end

  def set_most_ordered_product
    @most_ordered_product = Rails.cache.fetch('most_ordered_product', expires_in: 1.hour) do
      Product.joins(:order_details).group('products.id').order('COUNT(order_details.id) DESC').first
    end
  end
end
