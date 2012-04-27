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

require 'spec_helper'

describe CartItem do
  pending "add some examples to (or delete) #{__FILE__}"
end
