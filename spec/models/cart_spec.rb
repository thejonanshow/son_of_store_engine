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
#


require 'spec_helper'

describe Cart do
  let(:cart) { Fabricate(:cart) }
  let(:product) { Fabricate(:product) }

  context "#add_product_by_id" do
    it "adds a product to the cart" do
      cart.add_product_by_id(product.id)
      cart.products.should include product
    end
  end

  before(:each) do
    cart.add_product(product)
    cart.add_product(product)
    cart.add_product(product)
  end

  context "#total" do
    it "calculates the total price of its products" do
      cart.total.should be_within(0.001).of(product.price * 3)
    end
  end

  context "#subtotal" do
    it "returns the subtotal of all similar order products" do
      cart.subtotal(product).should be_within(0.001).of(product.price * 3)
    end
  end

  context "#quantity_for" do
    it "returns the quantity of all similar products" do
      cart.quantity_for(product).should == 3
    end
  end

  context "#items" do
    it "returns a collection" do
      cart.items.should be_a Enumerable
    end

    it "returns a collection of order items" do
      cart.items.sample.should be_a CartItem
    end
  end
end
