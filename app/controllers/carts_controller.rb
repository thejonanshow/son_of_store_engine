# Interface to manage carts for guests and users
class CartsController < ApplicationController
  before_filter :find_cart_from_session

  def show
  end

  def prompt
    redirect_to checkout_path if current_user
  end

  def update
    if params[:cart] && params[:cart][:cart_item]
      @cart.items.each do |item|
        item = CartItem.find(params[:cart][:cart_item][:id])
        item.update_attributes(params[:cart][:cart_item])
      end
    else
      @cart.add_product_by_id(params[:product_id])
    end

    redirect_to cart_path(@store)
  end

  def destroy
    cart.destroy
    session[:cart_id] = nil
    redirect_to cart_path
  end

  def checkout
    order = Order.create_from_cart(@cart, @store)
    order.update_attributes(:user_id => current_user.id) if current_user
    redirect_to edit_order_path(@store, order)
  end

  private 

    def find_cart_from_session
      @cart = Cart.find(session[:cart_id])
    end
end
