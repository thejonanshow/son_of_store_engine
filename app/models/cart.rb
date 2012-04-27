# == Schema Information
#
# Table name: carts
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

# A cart is an order with state, and becomes an order on checkout.
class Cart < ActiveRecord::Base
  attr_accessible :user_id

  has_many :cart_items
  has_many :products, :through => :cart_items
  belongs_to :store

  def add_product_by_id(product_id)
    add_product(Product.find(product_id))
  end

  def add_product(product)
    if products.include?(product)
      increment_quantity_for(product)
    else
      products << product
    end
  end

  def items
    cart_items
  end
end
