class CartItemsController < ApplicationController
    def destroy
        @cart_item = CartItem.find(params[:id])
        @cart_item.destroy
        redirect_to cart_path(current_user.cart), notice: 'Item removed from cart.'
    end
end
