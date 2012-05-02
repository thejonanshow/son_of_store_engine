require 'forwardable'

class CartItem < ActiveRecord::Base
  attr_accessible :cart_id, :product_id, :quantity
  belongs_to :cart
  belongs_to :product

  extend Forwardable

  def product
    @product ||= Product.find(product_id)
  end

  def subtotal
    price * quantity
  end

  def_delegators :product, :title, :price, :description, :photo
end