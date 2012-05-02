# Shows a user their orders
class OrdersController < ApplicationController
  before_filter :find_cart_from_session

  def new
    order = Order.create_from_cart(@cart, @store)
    order.update_attributes(:user_id => current_user.id) if current_user
    redirect_to edit_order_path(@store, order)
  end

  def show
    @order = @store.orders.find(params[:id])
    notice = "You are not authorized to view that order."
    redirect_to root_path, :notice => notice unless @order.user == current_user
  end

  def index
    @orders = []
    @orders = @store.orders.find_all_by_user_id(current_user.id) if current_user
  end

  def edit
    @order = Order.find(params[:id])
    session[:cart_id] = nil
  end

  def update
    order = Order.find(params[:id])
    params[:order][:email] = current_user.email unless params[:order][:email]
    order.update_with_billing_information(params)
    OrderMailer.confirmation_email(order).deliver
    redirect_to order_path(@store, order), :notice => "Order placed. Thank you!"
  end

  private 

    def find_cart_from_session
      @cart = Cart.find(session[:cart_id])
    end
end
