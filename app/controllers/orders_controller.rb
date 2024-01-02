class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def new
    @order = Order.new
  end

  def create
    @order = current_user.orders.build(order_params)
    cart_items = @cart.cart_items.includes(:product)

    cart_items.each do |cart_item|
      order_detail = @order.order_details.build(
        product: cart_item.product
      )
    end
    if @order.save
      Rails.cache.delete('most_ordered_product')
      current_user.cart.cart_items.destroy_all
      redirect_to products_path, notice: 'Order successfully placed.'
    else
      redirect_to products_path, alert: 'Order creation failed.'
    end
  end

  def show
    @order = Order.find_by(params[:id])
    @product_details = @order.product_details
  end

  def admin_index
    @orders = Order.all.page(params[:page]).per(5)
  end

  def most_ordered_product
    @most_ordered_product = Rails.cache.fetch('most_ordered_product', expires_in:1.hour) do
      Product.joins(:order_details).group('products.id').order('COUNT(order_details.id) DESC').first
    end
    @most_ordered_product
  end

  private

  def set_cart
    @cart = current_user.cart
  end

  def order_params
    params.require(:order).permit(:first_name, :last_name, :email, :address, :phone_number, :province)
  end
end
