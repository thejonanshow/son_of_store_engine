# == Schema Information
#
# Table name: carts
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  address_id :integer
#  store_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  email      :string(255)
#

# A cart is a place where a user places products, from which an order is created on checkout.
class Cart < ActiveRecord::Base

  attr_accessible :user_id,
                  :status,
                  :cart_items_attributes,
                  :address_id,
                  :email

  has_many :cart_items
  has_many :products, :through => :cart_items
  belongs_to :user
  belongs_to :store

  accepts_nested_attributes_for :cart_items

  # after_save :update_slug

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

  def increment_quantity_for(product)
    ci = CartItem.where(:cart_id => id).find_by_product_id(product.id)
    ci.update_attribute(:quantity, ci.quantity + 1)
  end

  def total
    cart_items.sum{|item| item.subtotal }
  end

  # def total
  #   @total ||= products.inject(0) { |sum, product| sum + subtotal(product) }
  # end

  def subtotal(product)
    ci = CartItem.where(:cart_id => id).find_by_product_id(product.id)
    (ci.quantity * ci.product.price).round(2)
  end

  def quantity_for(product)
    ci = CartItem.where(:cart_id => id).find_by_product_id(product.id)
    ci.quantity
  end

  def items
    cart_items
  end

  def update_with_billing_information(billing_data)
    update_attributes(billing_data[:order])

    Address.create_multiple([
      billing_data[:billing_address],
      billing_data[:shipping_address]
    ])

    CreditCard.create(billing_data[:credit_card])
  end

  # def update_slug
  #   unless slug
  #     update_attributes :slug => Digest::MD5.hexdigest([id, SLUG_SALT].join)
  #   end
  # end
end
