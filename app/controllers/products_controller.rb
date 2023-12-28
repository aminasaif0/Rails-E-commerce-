class ProductsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_product, only: [:show, :edit, :update, :destroy]
    before_action -> { authorize Product }

    def index
      @q = Product.ransack(params[:q])
      @products = @q.result(distinct: true)
      set_most_ordered_product
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
      @product = Product.find(params[:id])
      current_user.create_cart if current_user.cart.nil?
      current_user.cart.add_product(@product)
      redirect_to products_path, notice: 'Product added to cart.'
    end

    private
    def set_product
      @product = Product.find(params[:id])
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
