require 'forwardable'

# == Schema Information
#
# Table name: cart_items
#
#  id         :integer         not null, primary key
#  cart_id    :integer
#  product_id :integer
#  quantity   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class CartItem < ActiveRecord::Base
  attr_accessible :cart_id, :product_id, :quantity

  belongs_to :cart
  belongs_to :product

  extend Forwardable

  def product
    @product ||= Product.find(product_id)
  end

  def subtotal
    quantity * price
  end

  def_delegators :product, :title, :price, :description, :photo
end
