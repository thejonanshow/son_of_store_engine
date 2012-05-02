# This is used to add and remove items from a cart
class CartItemsController < ApplicationController

  def update
    cart_item = CartItem.find_by_id(params[:id])
    cart_item.update_attributes(params[:cart_item])
    redirect_to cart_path
  end

  def destroy
    cart = Cart.find(session[:cart_id])
    item = CartItem.find(params[:id])
    item.destroy
    redirect_to cart_path
  end
end
