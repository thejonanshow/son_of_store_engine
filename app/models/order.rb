# == Schema Information
#
# Table name: orders
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  status     :string(255)
#  address_id :integer
#  store_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  email      :string(255)
#  slug       :string(255)
#


# An order is created when a user checks out with products
class Order < ActiveRecord::Base
  attr_accessible :user_id,
                  :status,
                  :order_items_attributes,
                  :address_id,
                  :email,
                  :slug

  has_many :order_items
  has_many :products, :through => :order_items
  belongs_to :address
  has_one :cart
  belongs_to :user
  belongs_to :store

  accepts_nested_attributes_for :order_items

  after_save :update_slug

  def self.collect_by_status
    orders_by_status = {}
    Order.statuses.each do |status|
      orders_by_status[status] = Order.find_all_by_status(status)
    end
    orders_by_status
  end

  def self.statuses
    Order.all.map(&:status).uniq
  end

  def self.create_from_cart(cart, store)
    order = store.orders.create(:status => "pending")
    cart.cart_items.each { |cart_item| order.add_order_item(cart_item) }
    order.save
    order
  end

  def add_order_item(cart_item)
    self.order_items.create(:product_id => cart_item.product_id,
                            :quantity => cart_item.quantity)
  end

  def total
    @total ||= order_items.inject(0) do |sum, order_item|
      sum += order_item.subtotal
    end
  end

  def items
    order_items
  end

  def update_with_billing_information(billing_data)
    update_attributes(billing_data[:order])

    Address.create_multiple([
      billing_data[:billing_address],
      billing_data[:shipping_address]
    ])

    CreditCard.create(billing_data[:credit_card])
  end

  def update_slug
    unless slug
      update_attributes :slug => Digest::MD5.hexdigest([id, SLUG_SALT].join)
    end
  end
end
