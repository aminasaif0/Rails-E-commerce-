class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def new
    @order = Order.new
  end

  def create
    @order = current_user.orders.build(order_params)

    if @order.save
      current_user.cart.cart_items.destroy_all

      redirect_to products_path, notice: 'Order successfully placed.'
    else
      redirect_to products_path, alert: 'Order creation failed.'
    end
  end

  private

  def set_cart
    @cart = current_user.cart
  end

  def order_params
    params.require(:order).permit(:first_name, :last_name, :email, :address, :phone_number, :province)
  end
end
