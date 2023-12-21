class ProductsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_product, only: [:show, :edit, :update, :destroy]

    def index
      @products = Product.all
      byebug
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
        byebug
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
        render :edit
      end
    end

    def destroy
      @product.destroy
      redirect_to products_url, notice: 'Product was successfully destroyed.'
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :price, :category_id, :stock_quantity)
    end
end
